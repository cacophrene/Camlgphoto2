/* wrap-gphoto2-abilities-list.c - This file is part of the camlgphoto2 library
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
#include <stdio.h>

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
#include "gphoto2/gphoto2-port.h"
#include "gphoto2/gphoto2-port-info-list.h"
#include "wrap-header.h"

CAMLprim
value caml_gp_library_version(value vverb) {
  CAMLparam1(vverb);
  GPVersionVerbosity verb = Bool_val(vverb);
  const char **str = gp_library_version(verb);
  CAMLreturn(caml_copy_string_array(str));
}

CAMLprim
value caml_gp_abilities_list_load(value cont_val) {
  CAMLparam1(cont_val);
  GPContext *context = (GPContext *) Int_val(Field(cont_val, 0));
  CameraAbilitiesList *list;
  gp_abilities_list_new(&list);
  int ret = gp_abilities_list_load(list, context);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(list));
}

CAMLprim
value caml_gp_abilities_list_count(value list_val) {
  CAMLparam1(list_val);
  CameraAbilitiesList *list = AbilitiesList_val(list_val);
  int ret = gp_abilities_list_count(list);
  CHECK_RESULT(ret);
  CAMLreturn(Val_int(ret));
}

CAMLprim
value caml_gp_abilities_list_lookup_model(value list_val, value name_val) {
  CAMLparam2(name_val, list_val);
  CameraAbilitiesList *list = AbilitiesList_val(list_val);
  const char *model = String_val(name_val);
  int ret = gp_abilities_list_lookup_model(list, model);
  CAMLreturn(ret < 0 ? Val_false : Val_true);
}

CAMLprim
value caml_gp_abilities_list_free(value list_val) {
  CAMLparam1(list_val);
  CameraAbilitiesList *list = AbilitiesList_val(list_val);
  int ret = gp_abilities_list_free(list);
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}

CAMLprim
value caml_gp_abilities_list_get_abilities(value list_val, value name_val) {
  CAMLparam2(name_val, list_val);
  CameraAbilitiesList *list = AbilitiesList_val(list_val);
  const char *name = String_val(name_val);
  int index = gp_abilities_list_lookup_model(list, name);
  if (index < 0) raise_not_found();
  CameraAbilities *res = malloc(sizeof(*res));
  int ret = gp_abilities_list_get_abilities(list, index, res);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(res));
}

value Val_couples(CameraList* list, GPPortInfoList *info_list) {
  CAMLparam0();
  value data_val, cons_val, list_val;
  list_val = Val_emptylist;
  int i;
  for(i = 0; i < gp_list_count(list); i++) {
    const char *model, *port;
    gp_list_get_name (list, i, &model);
    gp_list_get_value (list, i, &port);
    data_val = caml_alloc(2, 0);
    int ret = gp_port_info_list_lookup_path(info_list, port);
    CHECK_RESULT(ret);
    GPPortInfo *info = malloc(sizeof(*info));
    ret = gp_port_info_list_get_info(info_list, ret, info);
    CHECK_RESULT(ret);
    Store_field(data_val, 0, caml_copy_string(model));
    Store_field(data_val, 1, encapsulate_pointer(info));     
    cons_val = caml_alloc(2, 0);
    Store_field(cons_val, 0, data_val);
    Store_field(cons_val, 1, list_val);    
    list_val = cons_val;
  }
  CAMLreturn(list_val);
}

CAMLprim
value caml_gp_abilities_list_detect(value list_val, value context_val) {
  CAMLparam2(list_val, context_val);
  GPContext* context = Context_val(context_val);
  CameraAbilitiesList *list = AbilitiesList_val(list_val);
  GPPortInfoList *info_list;
  gp_port_info_list_new(&info_list);
  int ret = gp_port_info_list_load(info_list);
  CHECK_RESULT(ret);
  CameraList *res;
  gp_list_new (&res);
  ret = gp_abilities_list_detect(list, info_list, res, context);
  CHECK_RESULT(ret);
  CAMLreturn(Val_couples(res, info_list));
}
