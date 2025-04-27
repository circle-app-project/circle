# Release Notes

### What's New
- Update to 0.1.2+7
- Add medication feature with notifications - yayyy!!🥳
- Users can now add medications, with a detailed comprehensive information about your medication
- The application can now notify them when its time to take their medication

### Bug Fixes

Fixed a shit ton of bugs, including but not limited to:

- notifications: fix notification schedules not appearing issue, add proper permissions for android
- meds: complete scheduling of medication doses 
- meds: find and link parent medication for each dose when fetching medication scheduled doses 
- meds: properly return results from get operations, fixing empty doses issues
- lint: replace deprecated members with generic selector 
- meds: add uuid to medication object, also pass that uuid to med activity records 
- ios: attempting to fix ios build issue, (not working btw smh)
- database: fix object box database issue with null dbStreak causing failed data retriever 
- meds: add more medication types to `medicationtype` enum 
- profile: made ui screen null safe, doesn't throw null errors anymore 
- navigation: deprecate go router & migrate to auto_route for navigation 
- ui: fix disappeared status bar icons bug
- And more

### Known Issues
- Issue where the app asks user to complete onboarding every time
- Minor touches and fixes to the medication details page
- Should update demo data from medication details page
- Overall improvements to the UI
- Write comprehensive tests for all features so far