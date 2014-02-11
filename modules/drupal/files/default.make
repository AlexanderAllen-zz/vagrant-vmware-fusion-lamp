; Test make file.
; ---------
core = 7.x
api = 2

; Core project
; ------------
; In order for your makefile to generate a full Drupal site, you must include
; a core project. This is usually Drupal core, but you can also specify
; alternative core projects like Pressflow. Note that makefiles included with
; install profiles *should not* include a core project.

projects[drupal][type] = "core"
projects[drupal][download][type] = "file"
projects[drupal][download][url] = http://ftp.drupal.org/files/projects/drupal-7.22.tar.gz

; Modules
projects[views][subdir] = "contrib"
projects[admin_menu][subdir] = "contrib"
projects[devel][subdir] = "contrib"

