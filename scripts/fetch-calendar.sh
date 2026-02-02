#!/bin/bash
# Fetch calendar events from Google Calendar and save as JSON
# Designed to be run locally and push to GitHub for Vercel deployment
# ONLY fetches M&D: Personal and deniseefer@gmail.com (per Dee's request)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/../calendar-events.json"

echo "📅 Fetching calendar events..."

# Fetch events from M&D Personal calendar (NOT the content calendar)
echo "  → M&D Personal calendar..."
MD_PERSONAL=$(gog calendar events "74a0dd51c146a3282d8cdb2010931c427ae1c7ad4729a8857ff34f676fbfbff6@group.calendar.google.com" \
  --account=deeandmeesh@gmail.com \
  --days=14 \
  --max=50 \
  --json 2>/dev/null || echo '{"events":[]}')

# Fetch events from deniseefer@gmail.com (Dee's personal)
echo "  → Dee's personal calendar..."
DEE_PERSONAL=$(gog calendar events \
  --account=deniseefer@gmail.com \
  --days=14 \
  --max=50 \
  --json 2>/dev/null || echo '{"events":[]}')

# Create combined JSON using jq
echo "  → Combining calendars..."

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Combine all events with source labels (only 2 calendars now)
cat > "$OUTPUT_FILE" << EOF
{
  "lastUpdated": "$TIMESTAMP",
  "calendars": [
    {
      "id": "md-personal",
      "name": "M&D Personal",
      "color": "#92e1c0",
      "events": $(echo "$MD_PERSONAL" | jq '.events // []')
    },
    {
      "id": "dee-personal",
      "name": "Dee",
      "color": "#9fc6e7",
      "events": $(echo "$DEE_PERSONAL" | jq '.events // []')
    }
  ]
}
EOF

echo "✅ Calendar data saved to: $OUTPUT_FILE"
echo "   Last updated: $TIMESTAMP"

# Show event count
TOTAL=$(jq '[.calendars[].events | length] | add' "$OUTPUT_FILE")
echo "   Total events: $TOTAL"
