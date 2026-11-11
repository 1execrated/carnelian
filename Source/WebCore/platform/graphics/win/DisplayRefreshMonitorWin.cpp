/*
 * Copyright (C) 2020 Sony Interactive Entertainment Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE INC. OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "config.h"
#include "DisplayRefreshMonitorWin.h"

#include <mmsystem.h>

namespace WebCore {

// One process wide bump, never handed back. a browser with a running refresh monitor wants
// 1 ms waits anyway, and timeEndPeriod racing the next timeBeginPeriod is what silently put
// the grain back to 15.6 ms.
static void ensureHighResolutionTimers()
{
    static bool raised { false };
    if (raised)
        return;

    raised = true;
    timeBeginPeriod(timerResolutionMs);
}

RefPtr<DisplayRefreshMonitorWin> DisplayRefreshMonitorWin::create(PlatformDisplayID displayID)
{
    return adoptRef(*new DisplayRefreshMonitorWin(displayID));
}

DisplayRefreshMonitorWin::DisplayRefreshMonitorWin(PlatformDisplayID displayID)
    : DisplayRefreshMonitor(displayID)
    , m_timer(RunLoop::mainSingleton(), "DisplayRefreshMonitorWin::Timer"_s, this, &DisplayRefreshMonitorWin::displayLinkCallbackFired)
    , m_currentUpdate({ 0, DefaultFramesPerSecond })
{
    // DisplayRefreshMonitor defaults this to 0, so the first tick that arrives while no client
    // has re-armed yet stops the timer, and the client then restarts it from now, which loses
    // the tick. at 100 hz that showed up as 10,21,10,21 ms and a 64 fps ceiling on a 100 hz
    // panel. mac uses 20, keep the clock running through a slow frame but still stop when idle.
    setMaxUnscheduledFireCount(20);

    updateRefreshRate();
}

void DisplayRefreshMonitorWin::updateRefreshRate()
{
    FramesPerSecond rate = screenRefreshRate().value_or(DefaultFramesPerSecond);

    // A driver that reports something absurd is worse than a 60 hz guess.
    if (rate < 1 || rate > 1000)
        rate = DefaultFramesPerSecond;

    if (rate == m_framesPerSecond)
        return;

    m_framesPerSecond = rate;
    m_currentUpdate = { 0, rate };
}

std::optional<FramesPerSecond> DisplayRefreshMonitorWin::displayNominalFramesPerSecond()
{
    return m_framesPerSecond;
}

void DisplayRefreshMonitorWin::displayLinkCallbackFired()
{
    displayLinkFired(m_currentUpdate);
    m_currentUpdate = m_currentUpdate.nextUpdate();
}

bool DisplayRefreshMonitorWin::startNotificationMechanism()
{
    // The mode can change while the app runs, a user switching to 100 hz or a laptop
    // moving between panels, so re-read it every time the mechanism starts.
    updateRefreshRate();

    // Windows rounds every wait up to its clock tick, 15.6 ms by default, so a 10 ms refresh
    // timer is delivered at 16 ms and a 100 hz panel is paced at 64 fps. raise the process to
    // 1 ms once a high refresh display shows up and leave it there. handing it back on every
    // stop just races the next start, which is what kept the 10 ms timer at 16 ms.
    if (m_framesPerSecond > 60)
        ensureHighResolutionTimers();

    if (!m_timer.isActive())
        m_timer.startRepeating(1000_ms / static_cast<double>(m_framesPerSecond));

    return true;
}

void DisplayRefreshMonitorWin::stopNotificationMechanism()
{
    m_timer.stop();
}

} // namespace WebCore
