# Tasktracker-v2

## Design Decisions

* A user becomes manager if he decides to manage some other user, there is no separate "Become Manager" button
* A user cannot assign a task to himself until he decides to manage himself
* A user can see the create task form, but he won't see any users in "assign to" if he is not managing anyone, and in that case he cannot proceed with creating the task
* A user can create time blocks only using the "Start Working" button, to maintain the date/time format consistency in the database.
* The user can change the time using the edit button
