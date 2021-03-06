/* wrap-gphoto2-file.c - This file is part of the camlgphoto2 library
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
#include <string.h>

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
value caml_gp_file_new(value unit) {
  CAMLparam0();
  CameraFile *cf;
  gp_file_new(&cf);
  CAMLreturn(encapsulate_pointer(cf));
}
CAMLprim
value caml_gp_file_new_from_fd(value fde_val) {
  CAMLparam1(fde_val);
  CameraFile *cf;
  gp_file_new_from_fd(&cf, Int_val(fde_val));
  CAMLreturn(encapsulate_pointer(cf));
}
#define REF_COUNT(fct) \
CAMLprim \
value caml_gp_file_##fct(value file_val) { \
  CAMLparam1(file_val); \
  CameraFile *file = File_val(file_val); \
  int ret = gp_file_##fct(file); \
  CHECK_RESULT(ret); \
  CAMLreturn(Val_unit); \
}
REF_COUNT(ref)
REF_COUNT(unref)
REF_COUNT(free)
CAMLprim
value caml_gp_file_open(value name_val) {
  CAMLparam1(name_val);
  const char *name = String_val(name_val);
  CameraFile *file;
  gp_file_new(&file);
  int ret = gp_file_open(file, name);
  if (ret != GP_OK) caml_failwith("libgphoto2: gp_file_open error"); 
  CAMLreturn(encapsulate_pointer(file));
}
CAMLprim
value caml_gp_file_save(value file_val, value name_val) {
  CAMLparam2(file_val, name_val);
  CameraFile *file = File_val(file_val);
  char *name = String_val(name_val);
  gp_file_save(file, name);
  CAMLreturn(Val_unit);
}
CAMLprim
value caml_gp_file_copy(value file_val) {
  CAMLparam1(file_val);
  CameraFile *src = File_val(file_val);
  CameraFile *dst;
  gp_file_new(&dst);
  int ret = gp_file_copy(dst, src);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(dst));
}
CAMLprim
value caml_gp_file_clean(value file_val) {
  CAMLparam1(file_val);
  CameraFile *file = File_val(file_val);
  int ret = gp_file_clean(file);
  CHECK_RESULT(ret);  
  CAMLreturn(Val_unit);
}
CAMLprim
value caml_gp_file_get_name(value file_val) {
  CAMLparam1(file_val);
  CameraFile *cam = File_val(file_val);
  const char *name;
  int ret = gp_file_get_name(cam, &name);
  CHECK_RESULT(ret);
  CAMLreturn(caml_copy_string(name)); 
}
CAMLprim
value caml_gp_file_set_name(value file_val, value name_val) {
  CAMLparam2(file_val, name_val);
  CameraFile *file = File_val(file_val);
  const char *name = String_val(name_val);
  int ret = gp_file_set_name(file, name);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}
CAMLprim
value caml_gp_file_get_mime_type(value file_val) {
  CAMLparam1(file_val);
  CameraFile *cam = File_val(file_val);
  const char *mime;
  int ret = gp_file_get_mime_type(cam, &mime);
  CHECK_RESULT(ret);
  CAMLreturn(caml_copy_string(mime));
}
CAMLprim
value caml_gp_file_set_mime_type(value file_val, value mime_val) {
  CAMLparam2(file_val, mime_val);
  CameraFile *file = File_val(file_val);
  const char *mime = String_val(mime_val);
  int ret = gp_file_set_mime_type(file, mime);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}
CAMLprim
value caml_gp_file_get_mtime(value file_val) {
  CAMLparam1(file_val);
  CAMLlocal1(time_val);
  CameraFile *file = File_val(file_val);  
  time_t t;
  int ret = gp_file_get_mtime(file, &t);
  CHECK_RESULT(ret);
  CAMLreturn(caml_copy_double(t));
}
CAMLprim
value caml_gp_file_set_mtime(value file_val, value time_val) {
  CAMLparam2(file_val, time_val);
  CameraFile *file = File_val(file_val);
  time_t time = Double_val(time_val);
  int ret = gp_file_set_mtime(file, time);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}
#define CAML_GP_FILE_FUNCTION(fct) \
CAMLprim \
value caml_gp_file_##fct(value file_val) { \
  CAMLparam1(file_val); \
  CameraFile *file = File_val(file_val); \
  int ret = gp_file_##fct(file); \
  if (ret != GP_OK) caml_invalid_argument("gp_file_##fct"); \
  CAMLreturn(Val_unit); \
}
CAML_GP_FILE_FUNCTION(detect_mime_type)
CAML_GP_FILE_FUNCTION(adjust_name_for_mime_type)

/*CAMLprim
value caml_gp_file_get_data_and_size(value file_val) {
  CAMLparam1(file_val);
  CAMLlocal1(data_val);
  CameraFile *file = File_val(file_val);
  const char *data;
  unsigned long size;
  int ret = gp_file_get_data_and_size(file, &data, &size);
  CHECK_RESULT(ret);
  char res[size + 1];
  strncat(res, data, size);
  data_val = caml_copy_string(res);
  CAMLreturn(data_val);
}*/
