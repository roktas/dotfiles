---
description: "Respond by referring to the screenshot on the system clipboard."
allowed-tools: Bash(wl-paste:*), Bash(pbpaste:*)
---

There is a screenshot in PNG format on the system clipboard. Do not attempt to determine the format of the content using
a command such as `file`; assume it is in PNG format.

- Save the image from the clipboard to a temporary directory using the commands specified below for each system:
  - Linux: `wl-paste`
  - OS X: `pbpaste`

- Respond to the “$ARGUMENTS” prompt by analysing the saved image.

- In some images, part of the image may be marked with a colored line (usually cyan or reddish). Limit the context of
  the prompt to the marked area.

- Remain silent and do not provide explanations when you are copying and analysing the image from the clipboard.
