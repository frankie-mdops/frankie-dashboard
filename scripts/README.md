# Frankie Dashboard Scripts

## fetch-calendar.sh

Fetches calendar events from Google Calendar and saves them to `calendar-events.json`.

### Usage

```bash
./scripts/fetch-calendar.sh
```

### Requirements
- `gog` CLI installed and authenticated
- `jq` for JSON processing

### Calendars Synced
1. **M&D Personal** - deeandmeesh@gmail.com (calendar ID: 74a0dd51...)
2. **M&D Content** - deeandmeesh@gmail.com primary calendar
3. **Dee** - deniseefer@gmail.com primary calendar

### Updating the Dashboard

1. Run the fetch script: `./scripts/fetch-calendar.sh`
2. Commit and push: `git add . && git commit -m "📅 Update calendar" && git push`
3. Vercel auto-deploys on push

### Automation Options

**Option A: Cron Job (Local)**
```bash
# Run every 4 hours
0 */4 * * * cd /Users/dees_agent/frankie-dashboard && ./scripts/fetch-calendar.sh && git add calendar-events.json && git commit -m "📅 Auto-sync calendar" && git push
```

**Option B: Manual Refresh**
Run the script whenever you want to update the calendar data on the dashboard.

**Option C: Frankie Heartbeat**
Have Frankie run the sync during heartbeat checks (recommended for automatic updates).
