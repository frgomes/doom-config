# Emacs Second Brain Setup Guide

This guide walks you through the complete setup of your Doom Emacs configuration for a "second brain" system with contacts, calendars, GTD/kanban, and mind mapping capabilities.

## ✅ Completed Setup

All configuration files have been created. Here's what has been set up:

### 1. Package Installation
The following packages have been added to `packages.el`:
- `org-vcard` - vCard import/export for contacts
- `ebdb` - Enhanced contact database
- `org-caldav` - CalDAV synchronization
- `org-kanban` - Kanban boards for projects
- `org-mind-map` - Mind mapping from org files

### 2. Doom Modules
- `org` module (already enabled)
- `calendar` module with Google Calendar support (newly enabled)

### 3. Directory Structure
Created at `~/Documents/org/`:
```
Documents/org/
├── contacts/      # Contact files and EBDB database
├── calendars/     # Calendar files and synchronization
├── gtd/          # GTD workflow files
│   ├── inbox.org
│   ├── tasks.org
│   ├── projects.org
│   └── meetings.org
├── kanban/       # Kanban board files
├── mindmaps/     # Generated mind map exports
├── projects/     # Project-specific org files
└── roam/         # org-roam database (if enabled)
```

### 4. Module Configurations
- **Contacts** (`modules/contacts/config.el`): Configured org-vcard, EBDB, and org-contacts
- **Calendar** (`modules/calendar/config.el`): Configured for Fastmail, iCloud, or Nextcloud
- **Kanban/GTD** (`modules/kanban/config.el`): Hybrid GTD with kanban visualization
- **Mind Mapping** (`modules/mindmap/config.el`): org-mind-map with GraphViz

## 🚀 Next Steps

### 1. Install Packages
Run this command to install all packages:
```bash
cd ~/.emacs.d
doom sync
```

### 2. Choose and Configure CalDAV/CardDAV Provider

Edit `secret.el` with your provider credentials:

#### For Fastmail (Recommended)
```elisp
;; Add to secret.el
(setq caldav-username "your-email@fastmail.com")
(setq caldav-password "your-app-password")
(setq org-caldav-url "https://caldav.fastmail.com/dav/calendars/user@fastmail.com/")
```

#### For iCloud
```elisp
;; Add to secret.el
(setq caldav-username "your-apple-id@icloud.com")
(setq caldav-password "your-app-specific-password")
(setq org-caldav-url "https://caldav.icloud.com/")
```

#### For Nextcloud
```elisp
;; Add to secret.el
(setq caldav-username "your-username")
(setq caldav-password "your-password")
(setq org-caldav-url "https://your-nextcloud.com/remote.php/dav/calendars/username/")
```

### 3. Initialize Services
After restarting Emacs, run these commands:
```elisp
M-x ebdb-initialize       ; Initialize contact database
M-x caldav-sync           ; Sync calendars (after configuring credentials)
```

### 4. Test the Setup

#### Contacts
- `SPC c i` - Import vCard file
- `SPC c e` - Export contacts to vCard
- `SPC c s` - Search contacts

#### Calendar
- `SPC c c` - Open calendar
- `SPC c s` - Sync CalDAV

#### GTD/Kanban
- `SPC g g` - Open GTD agenda
- `SPC g c` - Quick capture
- `SPC g k` - Open kanban view

#### Mind Mapping
- `SPC m g` - Generate mind map from current org file
- `SPC m p` - Export to PNG
- `SPC m o` - Open mindmaps directory

## 📱 Mobile Setup

### iOS
1. Install **Calendars** by Readdle or iOS native calendar app
2. Add CalDAV account with your provider details
3. Install **CardDAV-Sync** for contacts

### Android
1. Use **DAVx5** for CalDAV/CardDAV synchronization
2. Configure with same credentials as Emacs

## 💡 Tips & Best Practices

### GTD Workflow
1. **Inbox**: Capture everything with `SPC g c`
2. **Process**: Review inbox daily with `SPC g g`
3. **Organize**: Move tasks to appropriate projects
4. **Review**: Weekly review with custom agenda view
5. **Execute**: Work from Next Actions list

### Mind Mapping
- Create hierarchical org files for best results
- Use TODO keywords for task-based mind maps
- Export regularly to visualize progress

### Contacts
- Use consistent naming conventions
- Tag contacts for easy filtering
- Regular backup of EBDB database

## 🔧 Troubleshooting

### Calendar Sync Issues
- Check credentials in `secret.el`
- Verify CalDAV URL is correct
- Ensure app-specific passwords (not regular passwords) for services that require them

### Mind Map Generation
- Verify GraphViz is installed: `dot -V`
- Check export directory permissions: `~/org/mindmaps/`
- Try smaller org files first

### EBDB Issues
- Run `M-x ebdb-reload-database` if contacts not showing
- Check `org-contacts-files` points to correct location
- Verify vCard files have correct permissions

## 📚 Further Reading

- [Org Mode Manual](https://orgmode.org/manual/)
- [GTD by David Allen](https://gettingthingsdone.com/)
- [Doom Emacs Documentation](https://docs.doomemacs.org/)
- [org-roam Documentation](https://www.orgroam.com/) (if using roam)

## 🔄 Maintenance

### Weekly
1. Process inbox to zero
2. Review project progress
3. Sync calendars and contacts
4. Export important mind maps

### Monthly
1. Archive completed projects
2. Review and refine GTD workflow
3. Backup entire org directory
4. Update package configurations

## 🎯 Success Metrics

You'll know the setup is working when:
- [ ] Inbox processes to zero daily
- [ ] Calendar events sync bidirectionally
- [ ] Contacts accessible from Emacs
- [ ] Projects tracked in kanban view
- [ ] Mind maps generate without errors
- [ ] Mobile devices sync properly

---

Happy Emacs Second Brain! 🧠✨