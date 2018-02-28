// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import $ from "jquery"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function update_buttons() {
  $(".manage-button").each( (_, bb) => {
    let user_id = $(bb).data("user-id");
    let manage_id = $(bb).data("manage");
    if(manage_id == "") {
      $(bb).text("Manage");
    }
    else {
      $(bb).text("Unmanage");
    }
  });
}

function update_start_time_buttons() {
  $(".start-time-button").each( (_, bb) => {
    let user_id = $(bb).data("user-id");
    let task_id = $(bb).data("task-id");
    let len = $(bb).data("timeblocks-length")
    if(len == 0) {
      $(bb).text("Start Working")
    }
    else {
      $(bb).text("End Working")
    }
  });
}

function set_button(user_id, manage_id) {
  $(".manage-button").each( (_, bb) => {
    if (user_id == $(bb).data('user-id')) {
       $(bb).data("manage", manage_id);
    }
  });
}

function manage(user_id) {
  let text = JSON.stringify({
      manage: {
        manager_id: current_user_id,
        managee_id: user_id,
      }
  });

  $.ajax(manage_path,{
    method: "POST",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_button(user_id, resp.data.id); },
  });
}

function unmanage(user_id, manage_id) {
  $.ajax(manage_path + "/" + manage_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => { set_button(user_id, ""); },
  });
}

function manage_click(ev) {
  let btn = $(ev.target);
  let user_id = btn.data("user-id");
  let manage_id = btn.data("manage");
  if (manage_id == "") {
    manage(user_id);
  }
  else {
    unmanage(user_id, manage_id);
  }
}

function start_time_click(ev) {
  let btn = $(ev.target);
  let user_id = btn.data("user-id");
  let task_id = btn.data("task-id");
  let len = btn.data("timeblocks-length")
  let id = btn.data("timeblocks-id");
  if(len == 0) {
    insert_start_time(user_id, task_id);
  }
  else {

    insert_end_time(id, user_id, task_id);
  }
}

function insert_start_time(u_id, t_id) {
  let text = JSON.stringify({
      timeblocks : {
        start_time: new Date(),
        end_time: "null",
        assigned_id: u_id,
        task_id: t_id
      }
  });
  $.ajax(time_path,{
    method: "POST",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { console.log("inserted into database") },
  });
}

function insert_end_time(id, u_id, t_id) {
  let text = JSON.stringify({
      timeblocks : {
        end_time: new Date(),
      }
  });
  $.ajax(time_path+"/"+id,{
    method: "PUT",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { console.log("inserted into database") },
  });
}

function init_manage() {
  if(!$(".manage-button")) {
    return;
  }
  $(".manage-button").click(manage_click);
  update_buttons();
}

function init_start_time() {
  if(!$(".start-time-button")) {
    return;
  }
  $(".start-time-button").click(start_time_click);
  update_start_time_buttons();
}

$(init_manage);
$(init_start_time);
