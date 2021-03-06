/* wrap-gphoto2-camera.c - This file is part of the camlgphoto2 library
 *
 * Copyright (C) 2010 Edouard Evangelisti
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details. 
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include <time.h>

#include "caml/mlvalues.h"
#include "caml/alloc.h"
#include "caml/memory.h"
#include "caml/fail.h"
#include "caml/callback.h"

#include "gphoto2/gphoto2-file.h"
#include "gphoto2/gphoto2-result.h"
#include "gphoto2/gphoto2-context.h"
#include "gphoto2/gphoto2-abilities-list.h"
#include "gphoto2/gphoto2-port-version.h"
#include "gphoto2/gphoto2-version.h"
#include "gphoto2/gphoto2-camera.h"
#include "gphoto2/gphoto2-list.h"
#include "gphoto2/gphoto2-port-info-list.h"
#include "wrap-header.h"

CAMLprim
value caml_gp_camera_new(value unit_val) {
  CAMLparam0();
  Camera *cam;
  int ret = gp_camera_new(&cam);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(cam));
}
#define CAML_GP_CAMERA_FUNCTION(fct) \
CAMLprim \
value caml_gp_camera_##fct(value cam_val, value cont_val) { \
  CAMLparam2(cam_val, cont_val); \
  Camera *cam = Camera_val(cam_val); \
  GPContext *context = Context_val(cont_val); \
  int ret = gp_camera_##fct(cam, context); \
  CHECK_RESULT(ret); \
  CAMLreturn(Val_unit); \
}
CAML_GP_CAMERA_FUNCTION(init)
CAML_GP_CAMERA_FUNCTION(exit)
#define CAML_GP_CAMERA_GET_SOMETHING(fct) \
CAMLprim \
value caml_gp_camera_get_##fct(value cam_val, value cont_val) { \
  CAMLparam2(cam_val, cont_val); \
  CAMLlocal1(text_val); \
  Camera *cam = Camera_val(cam_val); \
  GPContext *context = Context_val(cont_val); \
  CameraText *text = malloc(sizeof(CameraText)); \
  int ret = gp_camera_get_##fct(cam, text, context); \
  CHECK_RESULT(ret); \
  text_val = caml_copy_string(text->text); \
  free(text); \
  CAMLreturn(text_val); \
}
CAML_GP_CAMERA_GET_SOMETHING(about)
CAML_GP_CAMERA_GET_SOMETHING(manual)
CAML_GP_CAMERA_GET_SOMETHING(summary)
CAMLprim
value caml_gp_camera_get_abilities(value cam_val) {
  CAMLparam1(cam_val);
  Camera *cam = Camera_val(cam_val);
  CameraAbilities *abil = malloc(sizeof(*abil));
  int ret = gp_camera_get_abilities(cam, abil);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(abil));
}
CAMLprim
value caml_gp_camera_set_abilities(value cam_val, value abil_val) {
  CAMLparam2(cam_val, abil_val);
  Camera *cam = Camera_val(cam_val);
  CameraAbilities *abil = Abilities_val(abil_val);
  int ret = gp_camera_set_abilities(cam, *abil);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}
CAMLprim
value caml_gp_camera_get_port_info(value cam_val) {
  CAMLparam1(cam_val);
  Camera *cam = Camera_val(cam_val);
  GPPortInfo *info = malloc(sizeof(*info));
  int ret = gp_camera_get_port_info(cam, info);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(info));
}
CAMLprim
value caml_gp_camera_set_port_info(value cam_val, value info_val) {
  CAMLparam2(cam_val, info_val);
  Camera *cam = Camera_val(cam_val);
  GPPortInfo *info = (GPPortInfo *) Int_val(Field(info_val, 0));
  int ret = gp_camera_set_port_info(cam, *info);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}

CAMLprim
value caml_gp_camera_ref(value cam_val) {
  CAMLparam1(cam_val);
  Camera *cam = Camera_val(cam_val);
  gp_camera_ref(cam);
  CAMLreturn(Val_unit);
}
CAMLprim
value caml_gp_camera_unref(value cam_val) {
  CAMLparam1(cam_val);
  Camera *cam = Camera_val(cam_val);
  gp_camera_unref(cam);
  CAMLreturn(Val_unit);
}
CAMLprim
value caml_gp_camera_free(value vcam) {
  CAMLparam1(vcam);
  Camera *camera = Camera_val(vcam);
  gp_camera_free(camera);
  CAMLreturn(Val_unit);
}
CAMLprim
value caml_gp_camera_capture_preview(value vcam, value vcon) {
  CAMLparam2(vcam, vcon);
  Camera *camera = Camera_val(vcam);
  GPContext *context = Context_val(vcon);
  CameraFile *file;
  gp_file_new(&file);
  gp_camera_capture_preview(camera, file, context);
  CAMLreturn(encapsulate_pointer(file));
}
CAMLprim
value caml_gp_camera_capture(value cam_val, value typ_val, value context_val) {
  CAMLparam3(cam_val, typ_val, context_val);
  CAMLlocal1(res_val);
  Camera *cam = Camera_val(cam_val);
  GPContext *context = Context_val(context_val);
  CameraCaptureType typ = Int_val(typ_val);
  CameraFilePath *res = malloc(sizeof(CameraFilePath));
  int ret = gp_camera_capture(cam, typ, res, context);
  CHECK_RESULT(ret);
  res_val = caml_alloc(2, 0);
  Store_field(res_val, 0, caml_copy_string(res->folder));
  Store_field(res_val, 1, caml_copy_string(res->name));
  free(res);
  CAMLreturn(res_val);
}

CAMLprim
value caml_gp_camera_get_config(value camera_val, value context_val) {
  CAMLparam2(camera_val, context_val);
  Camera *camera = Camera_val(camera_val);
  GPContext *context = Context_val(context_val);
  CameraWidget *widget;
  int ret = gp_camera_get_config(camera, &widget, context);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(widget));
}

CAMLprim
value caml_gp_camera_set_config(value camera_val, 
  value context_val, value widget_val) {
  CAMLparam3(camera_val, context_val, widget_val);
  Camera *camera = Camera_val(camera_val);
  GPContext *context = Context_val(context_val);
  CameraWidget *widget = Widget_val(widget_val);
  int ret = gp_camera_set_config(camera, widget, context);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}

CAMLprim
value caml_gp_camera_file_get(value camera_val, value folder_val, \
  value fname_val, value type_val, value context_val) {
  CAMLparam5(camera_val, folder_val, fname_val, type_val, context_val);
  Camera *camera = Camera_val(camera_val);
  GPContext *context = Context_val(context_val);
  const char *folder = String_val(folder_val);
  const char *fname = String_val(fname_val);
  CameraFileType ftype = (CameraFileType)Int_val(type_val);
  CameraFile *file;
  gp_file_new(&file);
  int ret = gp_camera_file_get(camera, folder, fname, ftype, file, context);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(file));
}

CAMLprim
value caml_gp_camera_file_delete(value camera_val, value folder_val, \
  value fname_val, value context_val) {
  CAMLparam4(camera_val, folder_val, fname_val, context_val);
  Camera *camera = Camera_val(camera_val);
  GPContext *context = Context_val(context_val);
  const char *folder = String_val(folder_val);
  const char *fname = String_val(fname_val); 
  int ret = gp_camera_file_delete(camera, folder, fname, context);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}

// TODO We need to complete this function to remove Val_unit
CAMLprim
value caml_gp_camera_file_get_info(value camera_val, value folder_val, \
  value fname_val, value context_val) {
  CAMLparam4(camera_val, folder_val, fname_val, context_val);
  Camera *camera = Camera_val(camera_val);
  GPContext *context = Context_val(context_val);
  const char *folder = String_val(folder_val);
  const char *fname = String_val(fname_val); 
  CameraFileInfo info;
  int ret = gp_camera_file_get_info (camera, folder, fname, &info, context);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}


