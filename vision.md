RackChief Vision

> Help me remember what I have, what I’m working toward, and what changed—with less effort than maintaining it manually.

Vision anchor · October 1, 2026

This document guides product decisions. It describes the intended experience, not features that already exist or a commitment to implement everything in the next release. Evolve the existing project in small, reviewable steps.

Purpose

RackChief is a personal homelab hub connecting infrastructure, projects, purchases, and documentation. It should answer four everyday questions:

• What do I have, and where do I find it?
• What am I working on, and what is the next step?
• What do I plan to buy, and what am I waiting for?
• What changed, how did I do it, and did it work?

Projects may take weeks or months because of budgeting, availability, or time. RackChief should retain their context during those pauses so returning to a project does not mean reconstructing the plan.

Who it serves

Build for my actual homelab and working habits first. Other people are welcome to use, adapt, or fork it, but broad market coverage is not a requirement.

Keep personal data, credentials, addresses, and integrations configurable. Provide understandable setup instructions. Avoid expanding the product solely to accommodate hypothetical workflows.

The experience: many capabilities, few places

The app should remain useful without AI, Telegram, or external automation. Ordinary controls must support the same operations as agent interactions.

|Main view|What it answers                                                                |
|---------|-------------------------------------------------------------------------------|
|Overview |What is active, planned, waiting, or needing attention?                        |
|Device   |What is here, how do I access it, what runs on it, and what work relates to it?|
|Project  |What is the goal, where does it stand, what comes next, and what happened?     |

Purchases, candidate listings, hardware groups, tasks, and change entries are supporting records. Their existence does not automatically justify separate navigation sections or administration screens. Manage them in the device or project context where they make sense.

A project can involve multiple devices or have no device yet. Linking a device should enrich the project, not become a prerequisite for capturing an idea.

Infrastructure without inventory busywork

Device records provide useful identity and access information: name, role, model when relevant, IP addresses, useful service links, and hosting relationships. VMs and containers can include their VMID and Proxmox host so I can find them without rediscovering everything through another interface.

Hardware detail is optional and proportional to its value. A grouped entry such as 4 × 8GB DDR3-2133, 32GB total is sufficient. The backend may parse that into quantity, capacity, generation, and speed without forcing four individual module records.

Track individual components only when their identity matters—for example, serial numbers, failed drives, or specific slot assignments. Avoid requiring fields I will never use.

Planned, ordered, received, and installed hardware are different states. A purchase must not change the device’s installed configuration until installation is recorded.

Later discovery integrations may import infrastructure facts. Define which facts are discovered and which are manually maintained so a refresh does not erase my notes or silently redefine my plans.

Projects that survive interruptions

Each project has a readable goal, current state, next step, relevant subitems, purchases, and recent updates. Support waiting for budget, waiting for delivery, blocked work, and deliberately paused plans without making those projects look abandoned or overdue by default.

The parent project should tell the current story at a glance. Detailed child items are useful when they have an independent status, budget, follow-up, or meaningful documentation. Simple steps remain checklists; every sentence does not become another record or page.

An update should preserve the original intent and adjust the current picture. Avoid generating long documents or deep trees that require opening dozens of pages to understand one project.

Purchase requirements outlive listings

Separate three concepts:

|Concept    |Meaning                                                                                       |
|-----------|----------------------------------------------------------------------------------------------|
|Requirement|What I need, why, quantity, budget, compatibility, and acceptable constraints                 |
|Candidate  |A possible listing or offer, with price, availability, seller details, and supporting evidence|
|Purchase   |The order I actually placed, its cost, delivery progress, and received items                  |

An unavailable listing does not erase the requirement or restart the project. Replacements remain subject to the original constraints unless I explicitly change them.

Keep budget separate from actual spending, item price separate from delivered cost, and tentative dates separate from commitments. Financial tracking here supports project decisions; it should not grow into a full personal finance application.

Background assistance

Scheduled research can find candidates, propose a preferred option, and monitor it. When price, availability, or seller terms materially change, the system can research replacements, update the proposed candidate with history, and notify me.

“No suitable candidate” is a valid outcome. Do not silently increase my budget, relax compatibility, or imply an item was purchased. Retain enough evidence and a last-checked time to make recommendations reviewable.

Notifications should be useful: a qualifying candidate, a meaningful change, a replacement, or a decision I need to make. Avoid repeatedly announcing unchanged listings. Scheduled assistance supports the plan; it does not require autonomous buying.

Documentation: current state and durable history

A concise overview shows what is true now. Dated change entries explain how it became true.

Capture what changed, when, why, how it was performed, and the outcome when those details are available. Configuration snippets, troubleshooting, photos, and longer reference material can support an entry without burying the current summary.

A short update is still useful. “Installed the RAM” should be captured without inventing module details or turning every update into a questionnaire. Request missing detail when it materially affects interpretation or a subsequent action.

Detailed documentation can initially remain in Trilium and be linked from RackChief. A rich editor or complete KB migration is not required to deliver a useful project overview. Choose longer-term document storage after the everyday flow is proven.

AI, code, and interfaces

|Responsibility                                                                                                     |Owner       |
|-------------------------------------------------------------------------------------------------------------------|------------|
|Commands, menus, explicit selection, status transitions, validation, persistence, schedules, and notification rules|App code    |
|Interpreting natural language, researching candidates, comparing options, and proposing structured changes         |AI          |
|Quick text/voice capture, project selection, questions, actionable notifications, and links to details             |Telegram    |
|Device/project browsing, manual editing, reviewing recommendations, and reading history                            |RackChief UI|

AI and manual controls use the same underlying application operations. “RAM arrived” and “Mark received” must produce consistent state and history.

Agent tools should expose useful operations such as retrieving project context or recording an update. The model should not need dozens of searches or traverse a note tree to assemble basic context. Tools should return focused information and verified outcomes.

Resolve obvious relationships automatically and ask only for meaningful ambiguity. Do not invent quantities, dates, costs, destinations, or successful actions. Explicit project selection takes precedence over guessing from text. Preserve enough source information to understand and correct an interpretation.

Telegram is first-class support for the app, not its entire control surface. Longer Apple Notes or meeting-note imports are a separate capture path: preserve source material, extract a useful summary, and distinguish discussion from committed actions. Both paths connect to the same projects and devices.

n8n may support early workflows and scheduled research. The vision does not require rebuilding an orchestration platform inside RackChief immediately.

Representative everyday flows

Record a hardware summary

“I have four 8GB DDR3-2133 modules in this device.”

Create or update a grouped hardware entry. Calculate the total and retain supplied specifications. Do not demand individual module forms or create duplicate hardware on repeated edits.

Plan an upgrade

“I’m planning to add RAM to my NAS.”

Find the NAS, reuse its existing upgrade project where appropriate, and add a RAM subitem if none exists. Capture the plan even without a final capacity, date, or budget. Keep it visible as planned work.

Record a purchase

“I’m buying six 8TB SAS drives for Artemis, $720 total, expected Tuesday.”

Link the order to Artemis and its relevant project, record pending delivery, and interpret the date with the user’s timezone. Preserve that $720 is the supplied total without inventing its tax/shipping breakdown. Do not show the drives as installed.

Resume after delivery

“The NAS drives arrived.”

Mark the matching order received and show installation or migration as the next step if already planned. Retain the project goal and remaining work.

Recover from a lost candidate

A monitored GPU listing sells out.

Keep the GPU requirement and budget, retain the previous candidate, search for replacements, and notify me of the new proposal or lack of a match. The project remains understandable throughout.

Retrieve infrastructure details

“Where is my MQTT container?”

Return the recorded hostname, IP, hosting server, VMID, and useful links directly. Clearly identify missing or stale information.

Document completed work

“Installed the RAM; Artemis now has 64GB.”

Update the relevant installed hardware summary, record project progress and a dated change, and preserve the supplied outcome. Do not claim testing passed unless it was reported.

Boundaries against sprawl

• Do not require exhaustive inventory, metadata design, or integration setup before getting value.
• Do not create a new screen for every backend entity.
• Do not fragment project context into an excessive number of notes or subitems.
• Do not make an LLM responsible for predictable app rules or the only way to edit records.
• Do not replace the existing backend simply because the vision expanded.
• Do not turn this into an enterprise ITSM system, a general project-management suite, or a full finance platform.
• Do not treat every envisioned capability as part of V1.

How to choose the next change

Before implementation, answer:

1. Which real user interaction becomes easier?
2. Where does it fit in an existing device, project, or overview page?
3. What must I maintain manually, and can any of it be inferred reliably?
4. Does it work through ordinary controls as well as AI?
5. What happens when a plan changes, a listing disappears, or an integration fails?
6. What is the smallest reviewable improvement that demonstrates the benefit?

Walk through the NAS upgrade using the existing app before redesigning it. Review the number of steps, the resulting overview, and how easy it is to resume later—not only whether a backend endpoint works.

Delivery direction

These are sequencing guides, not a simultaneous feature commitment:

1. Make existing device/asset flows dependable and simplify hardware entry.
2. Add useful dated changes linked to devices.
3. Make one project readable at a glance, with lightweight subitems and purchases.
4. Connect natural-language capture to the same validated operations.
5. Trial one monitored purchase requirement and meaningful candidate-change notifications.
6. Expand infrastructure discovery and longer-note capture where actual usage demonstrates value.

Inspect current implementation before choosing changes. Preserve useful work, avoid parallel implementations of the same behavior, and complete one end-to-end flow before expanding scope.

Success criteria

RackChief is succeeding when I can:

• Understand a device or project without opening many separate records.
• Capture a useful plan without filling out exhaustive forms.
• Return after several weeks and know the goal, current state, and next step.
• Find infrastructure access details without rediscovering them elsewhere.
• Replace a sold-out candidate without rebuilding the purchase plan.
• Read a trustworthy record of what changed and how it was done.
• Use the app directly even when AI or Telegram is unavailable.
• Spend more time on the homelab than maintaining RackChief’s data.

The anchor question: Does this change make my homelab easier to manage, or does it give me more app to maintain?