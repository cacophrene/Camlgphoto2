/* wrap-gphoto2-port-info-list.c - This file is part of the camlgphoto2 library
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

#define PORT_INFO_GET(any) \
CAMLprim \
value caml_gp_port_info_get_##any(value info_val) { \
  CAMLparam1(info_val); \
  GPPortInfo *info = (GPPortInfo *) Int_val(Field(info_val, 0)); \
  CAMLreturn(caml_copy_string(info->any)); \
}

PORT_INFO_GET(name)
PORT_INFO_GET(path)

CAMLprim
value caml_gp_port_info_get_type(value info_val) {
  CAMLparam1(info_val);
  int res = 0;
  GPPortInfo *info = (GPPortInfo *) Int_val(Field(info_val, 0));
  switch (info->type) {
    case 0: res = 0; break;
    case 1: res = 1; break;
    case 4: res = 2; break;
    case 8: res = 3; break;
    default: res = 4; break;
  }
  CAMLreturn(Val_int(res));
}
