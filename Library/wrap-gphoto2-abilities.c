/* wrap-gphoto2-abilities.c - This file is part of the camlgphoto2 library
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

#define GET_INT_FIELD(fct) \
CAMLprim \
value caml_gp_abilities_get_##fct(value abil_val) { \
  CAMLparam1(abil_val); \
  CameraAbilities *abil = Abilities_val(abil_val); \
  CAMLreturn(Val_int(abil->fct)); \
}
GET_INT_FIELD(status)
GET_INT_FIELD(device_type)
CAMLprim
value caml_gp_abilities_get_model(value abil_val) {
  CAMLparam1(abil_val);
  CameraAbilities *abil = Abilities_val(abil_val);
  CAMLreturn(caml_copy_string(abil->model));
}
CAMLprim
value caml_gp_abilities_get_operations(value ca_val) {
  CAMLparam1(ca_val);
  CameraAbilities *ca = Abilities_val(ca_val);
  CAMLreturn(Val_int(ca->operations));
}
CAMLprim
value caml_gp_abilities_get_file_operations(value ca_val) {
  CAMLparam1(ca_val);
  CameraAbilities *ca = Abilities_val(ca_val);
  CAMLreturn(Val_int(ca->file_operations));
}
CAMLprim
value caml_gp_abilities_get_folder_operations(value ca_val) {
  CAMLparam1(ca_val);
  CameraAbilities *ca = Abilities_val(ca_val);
  CAMLreturn(Val_int(ca->folder_operations));
}

