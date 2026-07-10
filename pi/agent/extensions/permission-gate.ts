/**
 * Permission Gate Extension
 *
 * Prompts for confirmation before running potentially dangerous bash commands.
 * Patterns checked: rm -rf, sudo, chmod/chown 777, destructive git commands
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const dangerousPatterns = [
    // Filesystem / privilege escalation
    // Recursive rm in any flag order/combination: -r, -rf, -fr, -vrf, -R, -Rf, --recursive
    /\brm\b[^\n]*?(--recursive\b|-[a-z]*r[a-z]*)\b/i,
    /\bsudo\b/i,
    /\b(chmod|chown)\b.*777/i,
    // Destructive git commands
    /\bgit\s+push\b.*(-f|--force|--force-with-lease)/i, // force push
    /\bgit\s+push\b.*--delete/i, // delete remote branch/tag
    /\bgit\s+branch\s+.*-D\b/i, // force delete local branch
    /\bgit\s+branch\s+.*--delete\s+--force/i, // force delete local branch (long form)
    /\bgit\s+tag\s+.*-d\b/i, // delete tag
    /\bgit\s+reset\s+--hard\b/i, // discard working-tree changes
    /\bgit\s+clean\s+.*-([a-z]*f[a-z]*|[a-z]*d[a-z]*)/i, // force-remove untracked files/dirs
    /\bgit\s+checkout\s+--\b/i, // discard local file changes (old syntax)
    /\bgit\s+restore\s+.*--staged?\b.*--worktree/i, // wipe staged + working changes
  ];

  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "bash") return undefined;

    const command = event.input.command as string;
    const isDangerous = dangerousPatterns.some((p) => p.test(command));

    if (isDangerous) {
      if (!ctx.hasUI) {
        // In non-interactive mode, block by default
        return { block: true, reason: "Dangerous command blocked (no UI for confirmation)" };
      }

      const choice = await ctx.ui.select(`⚠️ Dangerous command:\n\n  ${command}\n\nAllow?`, ["Yes", "No"]);

      if (choice !== "Yes") {
        return { block: true, reason: "Blocked by user" };
      }
    }

    return undefined;
  });
}
