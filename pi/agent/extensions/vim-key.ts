/**
 * vim-key extension
 *
 * Rolls up two vim-style conveniences into one extension:
 *   1. :q / :q! at the prompt to quit pi.
 *   2. ctrl+j / ctrl+k to navigate any dropdown (autocomplete, select lists, etc.).
 *
 * Drop into ~/.pi/agent/extensions/vim-key.ts (auto-discovered) or load with:
 *   pi -e ~/.pi/agent/extensions/vim-key.ts
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Key, matchesKey } from "@earendil-works/pi-tui";

export default function (pi: ExtensionAPI) {
  // ── 1. Vim-style quit via :q / :q! ────────────────────────────────
  pi.on("input", async (event, ctx) => {
    if (event.source !== "interactive") return { action: "continue" };

    const trimmed = event.text.trim();
    if (trimmed === ":q" || trimmed === ":q!") {
      ctx.shutdown();
      return { action: "handled" };
    }

    return { action: "continue" };
  });

  // ── 2. ctrl+j / ctrl+k → up / down remapping ────────────────────
  // Remap globally so every TUI component — autocomplete dropdown,
  // SelectList, etc. — responds to ctrl+j (down) and ctrl+k (up).
  //
  // Throttled to a minimum interval so key-repeat doesn't overshoot.
  const NAV_THROTTLE_MS = 55;
  let lastRemapTime = 0;
  let unsubInput: (() => void) | undefined;

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    lastRemapTime = 0;

    unsubInput = ctx.ui.onTerminalInput((data) => {
      const isJ = matchesKey(data, Key.ctrl("j"));
      const isK = matchesKey(data, Key.ctrl("k"));
      if (!isJ && !isK) return;

      const now = Date.now();
      if (now - lastRemapTime < NAV_THROTTLE_MS) {
        // Too soon — swallow the repeat so the dropdown doesn't fly past.
        return { consume: true };
      }
      lastRemapTime = now;
      return { data: isJ ? "\x1b[B" : "\x1b[A" };
    });
  });

  pi.on("session_shutdown", () => {
    unsubInput?.();
    unsubInput = undefined;
  });
}
