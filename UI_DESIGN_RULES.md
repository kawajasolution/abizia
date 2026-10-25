# HLS V2 UI Design Rules

1. Every page has exactly one visible primary title, rendered by the global header.
2. Do not repeat the page name in content headings. Use a section heading only when it identifies a different function.
3. New views must use the shared layout, header, panels, tables, filters, alerts, and action components.
4. Owner and Finance use the same page; permissions control visibility and server-side actions.
5. Navigation entries are active only when a real route and read permission exist. Unfinished features remain disabled.
6. New UI must follow these rules without changing approved business behavior or backend security.
7. Navigation between pages must preserve the sidebar scroll position. Page changes must not auto-scroll the sidebar; the active menu remains marked and its parent remains open.

8. Responsive behavior is required for desktop, tablet, and mobile. Small screens use the shared collapsible sidebar; page content must not overflow horizontally. Wide tables scroll inside their table container, while forms, filters, buttons, and panels reflow to the available width.
