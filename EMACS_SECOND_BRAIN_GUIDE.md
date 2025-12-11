# Emacs Second Brain Complete Guide

This comprehensive guide explains how to use your Emacs Second Brain system with contacts, calendar, GTD/kanban, and mind mapping capabilities.

## Table of Contents
1. [Introduction](#introduction)
2. [Contacts Management](#contacts-management)
3. [Calendar Management](#calendar-management)
4. [Kanban and GTD Workflow](#kanban-and-gtd-workflow)
5. [Mind Mapping](#mind-mapping)
6. [Integration Workflows](#integration-workflows)
7. [Keybindings Reference](#keybindings-reference)
8. [Common Tasks & Solutions](#common-tasks--solutions)

## Introduction

Your Emacs Second Brain is an integrated productivity system built on org-mode that helps you:
- Manage contacts and relationships
- Organize your calendar and events
- Track tasks and projects with GTD methodology
- Visualize ideas and projects with mind maps

### System Architecture
```
~/Documents/org/
├── contacts/      # Contact database
├── calendars/     # Calendar events and sync
├── gtd/          # GTD workflow files
├── kanban/       # Kanban board visualizations
├── mindmaps/     # Generated mind maps
└── projects/     # Project-specific files
```

## Contacts Management

Contacts are stored in org-mode format with support for vCard import/export and EBDB integration.

### Creating Contacts

#### Method 1: Manual Creation
1. Open `/home/rgomes/Documents/org/contacts/contacts.org`
2. Add a new entry with the following format:

```org
** Full Name
:PROPERTIES:
:EMAIL:    email@example.com
:PHONE:    +1-555-0123
:ADDRESS:  123 Main St, City, State ZIP
:WEBSITE:  https://example.com
:NOTES:    Additional notes about this contact
:BIRTHDAY: YYYY-MM-DD
:COMPANY:  Company Name
:END:
```

#### Method 2: Import from vCard
1. Press `C-c c i` to import a vCard file
2. Select your vCard (.vcf) file
3. Choose import options (append or replace)

#### Method 3: Using EBDB
1. Press `C-c c s` to open EBDB
2. Press `i` to insert a new contact
3. Fill in the contact details
4. Save with `C-c C-c`

### Example Contact Entry

```org
** Sarah Johnson
:PROPERTIES:
:EMAIL:    sarah.j@techcorp.com
:PHONE:    +1-555-0123
:ADDRESS:  456 Oak Ave, San Francisco, CA 94102
:WEBSITE:  https://sarahjohnson.dev
:NOTES:    Lead developer at TechCorp. Met at ReactConf 2023.
          Specializes in frontend architecture.
:BIRTHDAY: 1985-06-15
:COMPANY:  TechCorp Inc
:END:

** Michael Chen
:PROPERTIES:
:EMAIL:    mchen@design.studio
:PHONE:    +1-555-0456
:ADDRESS:  789 Pine St, Portland, OR 97201
:WEBSITE:  https://micheldesigns.com
:NOTES:    Freelance UI/UX designer. Referral from Jane Doe.
          Rates: $150/hour
:COMPANY:  Design Studio
:END:
```

### Maintaining Contacts

#### Searching Contacts
- **Quick search**: `C-c c s` to open EBDB and search
- **Org-mode search**: Use org-mode search within contacts.org
- **Tag-based filtering**: Add tags like `:client:`, `:colleague:`, `:family:`

#### Exporting Contacts
1. Press `C-c c e` to export contacts
2. Choose format (vCard)
3. Select destination file

#### Mobile Sync
1. Set up CardDAV with your provider (Fastmail, iCloud, Nextcloud)
2. Install CardDAV client on mobile device
3. Sync with the same CalDAV credentials as your calendar

## Calendar Management

Your calendar supports both local org-mode files and CalDAV synchronization with external services.

### Creating Calendar Entries

#### Method 1: Direct Entry
1. Open `/home/rgomes/Documents/org/calendars/personal.org`
2. Add entries under appropriate sections

#### Method 2: Using Calendar View
1. Press `C-c a c` to open calendar
2. Navigate to desired date
3. Press `i` to insert new event

#### Method 3: From Inbox
1. Press `C-c g c` to capture
2. Choose "Meeting" template
3. Enter details, it goes to inbox first
4. Process inbox to move to calendar files

### Calendar Entry Formats

#### Simple Event
```org
* Dentist Appointment
<2024-12-15 Sun 14:00-15:00>
:PROPERTIES:
:ID:       2024-12-15-dentist
:END:
Location: Downtown Dental Clinic
```

#### Meeting with Details
```org
* Q4 Planning Meeting
<2024-12-20 Fri 10:00-12:00>
:PROPERTIES:
:ID:       2024-12-20-q4-planning
:LOCATION: Conference Room A
:ATTENDEES: john@company.com, jane@company.com, team@company.com
:END:
** Agenda
- Review Q3 results
- Set Q4 objectives
- Resource allocation
** Pre-work
- Read Q3 report
- Prepare department goals
```

#### Recurring Event
```org
* Team Standup
<%%(and (diary-float t 4 1) (diary-block 9 12))>
<2024-01-01 Mon 09:00-09:30 +1w>
:PROPERTIES:
:ID:       team-standup
:END:
Recurring weekly team standup meeting
```

#### Appointment with Reminder
```org
* Doctor Consultation
<2024-12-18 Wed 15:30>
SCHEDULED: <2024-12-18 Wed 15:30>
:PROPERTIES:
:ID:       2024-12-18-doctor
:END:
Bring insurance card and list of medications
```

### Calendar Categories
Your calendar is organized into these sections:
- **Appointments**: Doctor visits, meetings, consultations
- **Reminders**: Bill due dates, renewals, follow-ups
- **Birthdays**: Contact birthdays (automatically from contacts)
- **Holidays**: Pre-configured US holidays

### Processing Calendar Inbox
1. Regularly check `/home/rgomes/Documents/org/calendars/inbox.org`
2. For each item:
   - Add proper timestamps
   - Categorize (move to appropriate section)
   - Add necessary properties
   - Delete from inbox

### Synchronization
- **Auto-sync**: Every 30 minutes
- **Manual sync**: `C-c a s`
- **View sync status**: Check messages in `*Messages*` buffer

## Kanban and GTD Workflow

The system combines GTD methodology with kanban visualization for effective task and project management.

### GTD Workflow Overview

#### 1. Capture Everything
Use `C-c g c` to quickly capture:
- `i` - Inbox item (quick thought)
- `t` - Task with details
- `p` - New project
- `m` - Meeting notes

#### 2. Process Inbox
Daily review of `/home/rgomes/Documents/org/gtd/inbox.org`
- Delete what's not needed
- Delegate (add waiting tag)
- Defer (schedule)
- Do (if < 2 minutes)
- Organize into projects/tasks

#### 3. Organize
- Tasks go to `tasks.org`
- Projects go to `projects.org`
- Reference material gets filed

#### 4. Review
- Weekly review with `C-c g a`
- Project status updates
- Next action selection

#### 5. Engage
- Work from NEXT actions list
- Use calendar for time-specific tasks
- Focus on one thing at a time

### Creating Tasks

#### Simple Task
```org
* NEXT Buy groceries
:PROPERTIES:
:EFFORT:   0:30
:CONTEXT:  errands
:END:
- [ ] Milk
- [ ] Eggs
- [ ] Bread
```

#### Project Task
```org
* IN-PROGRESS Write project proposal
:PROPERTIES:
:EFFORT:   3:00
:PROJECT:  client-x-website
:PRIORITY: A
:END:
- [ ] Research client requirements
- [ ] Create outline
- [ ] Draft content
- [ ] Review and edit
```

#### Waiting For Task
```org
* WAITING Approval from client
:PROPERTIES:
:WAITING:  client-x
:DEADLINE: <2024-12-25 Tue>
:END:
Sent on 2024-12-11, waiting for feedback
```

### Managing Projects

#### Project Structure
```org
* PROJECT Website Redesign for Client
:PROPERTIES:
:ID:       proj-website-redesign
:START:    <2024-12-01>
:DEADLINE: <2025-02-28>
:END:

** DONE Initial consultation and requirements
** NEXT Create wireframes
** IN-PROGRESS Design mockups
** WAITING Client approval on mockups
** TODO Frontend development
** TODO Backend integration
** SOMEDAY Future feature: Shopping cart

* Notes
- Client wants modern, minimalist design
- Budget: $15,000
- Must be mobile-responsive
```

#### Kanban View
1. Open project file
2. Press `C-c g k` to see kanban board
3. Navigate with `n` (next) and `p` (previous)
4. Move tasks with `l` (left) and `r` (right)

### Weekly Review Process
1. Press `C-c g a` to open GTD agenda
2. Review:
   - All projects (status, next actions)
   - Waiting items (follow up)
   - Someday/Maybe (activate any)
   - Calendar (past week, upcoming)
3. Clean up:
   - Mark completed items as DONE
   - Move or delete irrelevant items
   - Update project plans

## Mind Mapping

Create visual mind maps from your org-mode files to see relationships and plan projects.

### Creating Mind Maps

#### Step 1: Prepare Your Org File
Create a hierarchical structure:

```org
# Project Launch Plan
* Phase 1: Preparation
** Market Research
*** Competitor analysis
*** Target audience survey
** Budget Planning
*** Initial quote
*** Resource allocation
** Team Assembly
*** Hire designer
*** Contract developer

* Phase 2: Development
** Design Phase
*** Wireframes
*** Mockups
*** Style guide
** Development
*** Frontend coding
*** Backend setup
*** Database design

* Phase 3: Launch
** Testing
*** Unit tests
*** User acceptance
** Marketing
*** Social media campaign
*** Email announcement
** Deployment
*** Server setup
*** Go live
```

#### Step 2: Generate Mind Map
1. Open the org file
2. Press `C-c m g` to generate
3. Choose export format:
   - `C-c m p` - PNG (high quality, 300 DPI)
   - `C-c m s` - SVG (scalable vector)
   - `C-c m d` - PDF (for documents)

#### Step 3: View and Share
1. Press `C-c m o` to open mindmaps directory
2. Find your exported file
3. Share or include in presentations

#### Step 4: Generate from Org-Roam Node
1. Open any org-roam note
2. Press `C-c m r` to generate mind map from current node
3. Mind map automatically saves with node ID

### Mind Map Customization

#### Color Coding
The system automatically colors TODO states:
- TODO/INBOX: Red
- NEXT: Yellow
- IN-PROGRESS: Blue
- WAITING: Orange
- DONE: Green
- CANCELLED: Gray

#### Advanced Example
```org
# Knowledge Management System
* Data Sources
** Internal documents
*** Company wikis
*** Project documentation
*** Meeting notes
** External resources
*** Industry blogs
*** Research papers
*** Online courses

* Organization Methods
** Tagging system
*** Primary tags
*** Context tags
*** Project tags
** Note linking
*** Cross-references
*** Backlinks
** Archive strategy
*** Monthly archive
*** Project completion

* Tools & Technologies
** org-roam
*** Bidirectional links
*** Daily notes
*** Graph view
** Storage solutions
*** Cloud storage
*** Local backup
*** Git version control
```

### Best Practices
1. Keep hierarchy shallow (3-4 levels max)
2. Use clear, concise headings
3. Include TODO keywords for progress tracking
4. Export regularly for project updates
5. Use consistent structure across similar projects

## Integration Workflows

### Workflow 1: From Contact to Project
1. **Create contact**: Add new client to contacts.org (`C-c c c`)
2. **Capture initial request**: `C-c g c` → `p` (project)
3. **Schedule kickoff**: Create calendar event (`C-c a c`) with contact link
4. **Track in kanban**: Move through project phases (`C-c g k`)
5. **Generate mind map**: Visualize project structure (`C-c m g`)

### Workflow 2: Meeting Management
1. **Schedule meeting**: Calendar entry with attendee links
2. **Prepare agenda**: Create org-roam note with linked contacts (`C-c n f`)
3. **Take notes**: Use meeting capture template (`C-c g c` → `m`)
4. **Extract actions**: Process notes into GTD tasks
5. **Follow up**: Track waiting items to completion

### Workflow 3: Daily Planning
1. **Review calendar**: Check today's appointments
2. **Check GTD agenda**: `C-c g a` for today's tasks
3. **Review notes**: Check org-roam backlinks (`C-c n b`)
4. **Capture new items**: Use inbox throughout day (`C-c g c`)
5. **Evening review**: Process inbox and create tomorrow's note (`C-c n t`)

## Keybindings Reference

### Contacts (`C-c c`)
| Key | Command | Description |
|-----|---------|-------------|
| `C-c c c` | `org-capture-contacts` | Create new contact |
| `C-c c i` | `org-vcard-import` | Import vCard file |
| `C-c c e` | `org-vcard-export` | Export contacts |
| `C-c c s` | `ebdb` | Search contacts |

### Calendar (`C-c a`)
| Key | Command | Description |
|-----|---------|-------------|
| `C-c a c` | `calendar` | Open calendar view |
| `C-c a s` | `caldav-sync` | Manual sync |
| `C-c a o` | `org-calendar-view` | Org calendar integration |

### GTD/Kanban (`C-c g`)
| Key | Command | Description |
|-----|---------|-------------|
| `C-c g a` | `org-agenda` | Open GTD agenda |
| `C-c g c` | `org-capture` | Quick capture |
| `C-c g i` | Find inbox | Go to inbox file |
| `C-c g k` | `org-kanban` | Open kanban view |

### Mind Mapping (`C-c m`)
| Key | Command | Description |
|-----|---------|-------------|
| `C-c m g` | `org-mind-map` | Generate from current file |
| `C-c m p` | Export to PNG | Create PNG image |
| `C-c m s` | Export to SVG | Create SVG image |
| `C-c m d` | Export to PDF | Create PDF document |
| `C-c m o` | Open directory | View exported maps |
| `C-c m r` | Generate from roam | Create mind map from org-roam node |

### Org-Roam (Notes) (`C-c n`)
| Key | Command | Description |
|-----|---------|-------------|
| `C-c n f` | `org-roam-node-find` | Find note |
| `C-c n i` | `org-roam-node-insert` | Insert link to note |
| `C-c n b` | `org-roam-buffer-toggle` | Toggle backlinks buffer |
| `C-c n g` | `org-roam-graph` | Show graph view |
| `C-c n d` | `org-roam-dailies-goto-date` | Go to daily note |
| `C-c n t` | `org-roam-dailies-capture-today` | Today's daily note |
| `C-c n c` | `org-roam-capture` | Quick capture to roam |
| `C-c n a` | `org-roam-alias-add` | Add alias to note |

## Common Tasks & Solutions

### Importing Existing Contacts
1. Export from your current system as vCard
2. Place file in accessible location
3. `C-c c i` → select file → choose import mode
4. Review and categorize imported contacts

### Setting Up Mobile Sync
1. Choose provider (Fastmail recommended)
2. Create app-specific password
3. Add credentials to `secret.el`
4. Configure CalDAV/CardDAV on mobile
5. Test sync both directions

### Creating Recurring Calendar Events
```org
* Weekly Team Meeting
<2024-01-01 Mon 10:00-11:00 +1w>
- Recurs every Monday
```

### Managing Project Dependencies
Use TODO state workflows:
```org
* TODO Feature A
* TODO Feature B
* TODO Integration testing
```
Feature B can't start until A is done, integration after both.

### Exporting Mind Maps for Presentations
1. Create clean org structure
2. Export as SVG for scalability
3. Import into presentation software
4. Or export as PDF for handouts

### Backup Strategy
1. Daily: Git commit of org directory
2. Weekly: Full backup to cloud storage
3. Monthly: Archive old projects
4. Include EBDB database in backup

---

## Tips for Success

1. **Start small**: Begin with one component, add others gradually
2. **Daily habits**: Process inbox every day, even if just for 5 minutes
3. **Weekly review**: Never skip the weekly GTD review
4. **Keep it simple**: Don't over-organize; let the system grow with your needs
5. **Regular maintenance**: Clean up old items, update contacts, sync regularly

Remember: The goal is to have a trusted system that captures everything so your brain can focus on creative work, not on remembering!