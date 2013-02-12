dynamisaurus-rects
==================

Dynamic Non-Linear JSON-backed Spreadsheet, currently written in Processing

Current Features:
* Open any well-formed json file and display it sanely
* Collapse any array or object, completely or as a summary
* Add "rex-ordering" array to source json, to specify display order of keys
* Add "rex-primaries" dictionary to specify summary fields
* Edit any field (Key, String, Integer, Double, Boolean)
* Changes save automatically
* Snazzy gray-scale nesting indication
* All library calls are in one file, that can be stubbed out for Processing.js use

Planned Features:
* Change field types
* Move nodes graphically (drag to place)
* Add/remove nodes
* Duplicate/Template existing nodes
* Auto-calculated fields (similar to Excel)

Installation:
copy "json" folder from repo root to "libraries" folder in Processing's documents directory.

