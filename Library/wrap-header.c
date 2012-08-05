/* wrap-header.c - This file is part of the camlgphoto2 library
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

// caml headers
#include "caml/mlvalues.h"
#include "caml/alloc.h"
#include "caml/memory.h"
#include "caml/fail.h"
#include "caml/callback.h"

//useful macros
#define File_val(x) (CameraFile *) Int_val(Field((x), 0))
#define Camera_val(x) (Camera *) Int_val(Field((x), 0))
#define Context_val(x) (GPContext *) Int_val(Field((x), 0))
#define Abilities_val(x) (CameraAbilities *) Int_val(Field((x), 0))
#define AbilitiesList_val(x) (CameraAbilitiesList *) Int_val(Field((x), 0))
#define CHECK_RESULT(x) if ((x) < 0) caml_failwith(gp_port_result_as_string(x))
#define Widget_val(v) (CameraWidget *) Int_val(Field((v), 0))

//aux functions
value encapsulate_pointer(void *ptr) {
  value abstr = caml_alloc(1, Abstract_tag);
  Store_field(abstr, 0, Val_int(ptr));
  return(abstr);
}
