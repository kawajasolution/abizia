# Project instructions

Before changing any user interface, read `UI_DESIGN_RULES.md` and apply it to every new or modified view. Preserve shared layout components, RBAC, branch scope, CSRF, and existing business rules.

Sidebar navigation must preserve scroll position across page navigation and must not auto-scroll to the active item.

UI responsiveness is mandatory across desktop/web, tablet, and mobile. Preserve the shared drawer sidebar on small screens, prevent page-level horizontal overflow, keep wide tables scrollable inside their table container, and ensure forms, filters, buttons, and content reflow within the viewport.

Roadmap fitur dan ketergantungan bisnis berada di docs/HLS_V2_ROADMAP.md; baca dokumen itu sebelum merencanakan atau mengaktifkan modul baru.
