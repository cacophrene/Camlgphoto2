/* wrap-gphoto2-widget.c - This file is part of the camlgphoto2 library
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
value caml_gp_widget_new(value type_val, value label_val) {
  CAMLparam2(type_val, label_val);
  const char *label = String_val(label_val);
  CameraWidgetType type = Int_val(type_val);
  CameraWidget *widg;
  int ret = gp_widget_new(type, label, &widg);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(widg));
}

#define GP_WIDGET_MEMORY(fct) \
CAMLprim \
value caml_gp_widget_##fct(value widg_val) { \
  CAMLparam1(widg_val); \
  CameraWidget *widg = Widget_val(widg_val); \
  int ret = gp_widget_##fct(widg); \
  CHECK_RESULT(ret); \
  CAMLreturn(Val_unit); \
}

GP_WIDGET_MEMORY(ref)
GP_WIDGET_MEMORY(unref)
GP_WIDGET_MEMORY(free)

#define GP_WIDGET_GET_STRING(fct) \
CAMLprim \
value caml_gp_widget_get_##fct(value widg_val) { \
  CAMLparam1(widg_val); \
  CameraWidget *widg = Widget_val(widg_val); \
  const char *str; \
  int ret = gp_widget_get_##fct(widg, &str); \
  CHECK_RESULT(ret); \
  CAMLreturn(caml_copy_string(str)); \
}

GP_WIDGET_GET_STRING(info)
GP_WIDGET_GET_STRING(name)
GP_WIDGET_GET_STRING(label)

#define GP_WIDGET_SET_STRING(fct) \
CAMLprim \
value caml_gp_widget_set_##fct(value widg_val, value text_val) { \
  CAMLparam2(widg_val, text_val); \
  const char *text = String_val(text_val); \
  CameraWidget *widg = Widget_val(widg_val); \
  int ret = gp_widget_set_##fct(widg, text); \
  CHECK_RESULT(ret); \
  CAMLreturn(Val_unit); \
}

GP_WIDGET_SET_STRING(info)
GP_WIDGET_SET_STRING(name)

#define GP_WIDGET_GET_INT(fct, typ) \
CAMLprim \
value caml_gp_widget_get_##fct(value widg_val) { \
  CAMLparam1(widg_val); \
  CameraWidget *widg = Widget_val(widg_val); \
  typ res = 1; \
  int ret = gp_widget_get_##fct(widg, &res); \
  CHECK_RESULT(ret); \
  CAMLreturn(Val_int(res)); \
}

GP_WIDGET_GET_INT(id, int)
GP_WIDGET_GET_INT(type, CameraWidgetType)

CAMLprim
value caml_gp_widget_count_children(value widg_val) {
  CAMLparam1(widg_val);
  CameraWidget *widg = Widget_val(widg_val);
  int ret = gp_widget_count_children(widg);
  CHECK_RESULT(ret);
  CAMLreturn(Val_int(ret));
}

CAMLprim
value caml_gp_widget_get_child(value widg_val, value wnum_val) {
  CAMLparam2(widg_val, wnum_val);
  CameraWidget *widg = Widget_val(widg_val);
  int wnum = Int_val(wnum_val);
  CameraWidget *child;
  int ret = gp_widget_new(GP_WIDGET_TEXT, "foo", &child);
  CHECK_RESULT(ret);
  ret = gp_widget_get_child(widg, wnum, &child);
  CHECK_RESULT(ret);
  CAMLreturn(encapsulate_pointer(child));
}

#include <stdio.h>
CAMLprim
value caml_gp_widget_get_children(value widg_val) {
  CAMLparam1(widg_val);
  CAMLlocal2(cons_val, list_val);
  int i, ret;
  list_val = Val_emptylist;
  CameraWidget *widg = Widget_val(widg_val);
  CameraWidget *child;
  ret = gp_widget_new(GP_WIDGET_TEXT, "foo", &child);
  CHECK_RESULT(ret);
  for(i = gp_widget_count_children(widg); i > 0; i--) {
    ret = gp_widget_get_child(widg, i - 1, &child);
    CHECK_RESULT(ret);
    cons_val = caml_alloc(2, 0);
    Store_field(cons_val, 0, encapsulate_pointer(child));
    Store_field(cons_val, 1, list_val);
    list_val = cons_val;
  }
  CAMLreturn(list_val);
}

CAMLprim
value caml_gp_widget_get_readonly(value widg_val) {
  CAMLparam1(widg_val);
  CameraWidget *widg = Widget_val(widg_val);
  int state = 1;
  int ret = gp_widget_get_readonly(widg, &state);
  CHECK_RESULT(ret);
  CAMLreturn(state ? Val_true : Val_false);
}

#define GP_WIDGET_GET_WIDGET(fct) \
CAMLprim \
value caml_gp_widget_get_##fct(value widg_val) { \
  CAMLparam1(widg_val); \
  CameraWidget *widg = Widget_val(widg_val); \
  CameraWidget *res; \
  int ret = gp_widget_new(GP_WIDGET_TEXT, "foo", &res); \
  CHECK_RESULT(ret); \
  ret = gp_widget_get_##fct(widg, &res); \
  CHECK_RESULT(ret); \
  CAMLreturn(encapsulate_pointer(res)); \
}

GP_WIDGET_GET_WIDGET(parent)
GP_WIDGET_GET_WIDGET(root)

#define GP_WIDGET_GET_BY_STRING(fct) \
CAMLprim \
value caml_gp_widget_get_child_by_##fct(value widg_val, value text_val) { \
  CAMLparam2(widg_val, text_val); \
  CameraWidget *widg = Widget_val(widg_val); \
  const char *text = String_val(text_val); \
  CameraWidget *child; \
  int ret = gp_widget_new(GP_WIDGET_TEXT, "foo", &child); \
  CHECK_RESULT(ret); \
  ret = gp_widget_get_child_by_##fct(widg, text, &child); \
  if (ret != GP_OK) caml_raise_not_found(); \
  CAMLreturn(encapsulate_pointer(child)); \
}

GP_WIDGET_GET_BY_STRING(label)
GP_WIDGET_GET_BY_STRING(name)

CAMLprim
value caml_gp_widget_get_choices(value widg_val) {
  CAMLparam1(widg_val);
  CAMLlocal3(tuple_val, cons_val, list_val);
  int ret, i;
  CameraWidget *widg = Widget_val(widg_val);
  CameraWidgetType type = GP_WIDGET_RANGE;
  ret = gp_widget_get_type(widg, &type);
  CHECK_RESULT(ret);
  list_val = Val_emptylist;
  switch(type) {
    case GP_WIDGET_MENU:
    case GP_WIDGET_RADIO:
      for(i = gp_widget_count_choices(widg); i > 0; i--) {
        const char *choice;
        ret = gp_widget_get_choice(widg, i - 1, &choice);
        CHECK_RESULT(ret);
        tuple_val = caml_alloc(2, 0);
        Store_field(tuple_val, 0, caml_copy_string(choice));
        Store_field(tuple_val, 1, Val_int(i - 1));
        cons_val = caml_alloc(2, 0);
        Store_field(cons_val, 0, tuple_val);
        Store_field(cons_val, 1, list_val);
        list_val = cons_val;
      }
      break;
    default:
      caml_invalid_argument("Bad widget type"); break;
  }  
  CAMLreturn(list_val);
}

int	gp_widget_count_choices  (CameraWidget *widget);
int	gp_widget_get_choice     (CameraWidget *widget, int choice_number, 
                                  const char **choice);

CAMLprim
value caml_gp_widget_get_child_by_id(value widg_val, value id_val) {
  CAMLparam2(widg_val, id_val);
  CameraWidget *widg = Widget_val(widg_val);
  int id = Int_val(id_val);
  CameraWidget *child;
  int ret = gp_widget_new(GP_WIDGET_TEXT, "foo", &child);
  CHECK_RESULT(ret);
  ret = gp_widget_get_child_by_id(widg, id, &child);
  if (ret != GP_OK) caml_raise_not_found();
  CAMLreturn(encapsulate_pointer(child));
}

CAMLprim
value caml_gp_widget_get_value(value widg_val) {
  CAMLparam1(widg_val);
  CAMLlocal1(data_val);
  int ret;
  CameraWidget *widg = Widget_val(widg_val);
  CameraWidgetType type = GP_WIDGET_RANGE;
  ret = gp_widget_get_type(widg, &type);
  CHECK_RESULT(ret);
  switch (type) {
    case GP_WIDGET_RANGE: {
      double flo;
      ret = gp_widget_get_value(widg, &flo);
      CHECK_RESULT(ret);
      data_val = caml_alloc(1, 1);
      Store_field(data_val, 9, caml_copy_double(flo));
      break;
    }
    case GP_WIDGET_DATE:
    case GP_WIDGET_TOGGLE: {
      int itg;
      ret = gp_widget_get_value(widg, &itg);
      CHECK_RESULT(ret);
      data_val = caml_alloc(1, 0);
      Store_field(data_val, 0, Val_int(itg));
      break;
    }
    case GP_WIDGET_MENU:
    case GP_WIDGET_TEXT:
    case GP_WIDGET_RADIO: {
      char *str;
      ret = gp_widget_get_value(widg, &str);
      CHECK_RESULT(ret);
      data_val = caml_alloc(1, 2);
      Store_field(data_val, 0, caml_copy_string(str));
      break;
    }
    default: /* Other cases. */
      data_val = Val_int(0);
      break;
  }
  CAMLreturn(data_val);
}

CAMLprim
value caml_gp_widget_set_value(value widg_val, value value_val) {
  CAMLparam2(widg_val, value_val);
  CAMLlocal1(data_val);
  data_val = Field(value_val, 0);
  CameraWidget *widg = Widget_val(widg_val);
  int ret = 0;
  switch (Tag_val(data_val)) {
    case Double_tag: {
      double x = Double_val(data_val);
      ret = gp_widget_set_value(widg, &x);
      break;  }
    case String_tag: {
      const char* s = String_val(data_val);
      ret = gp_widget_set_value(widg, s);
      break; }
    default:{
      int n = Int_val(data_val);
      ret = gp_widget_set_value(widg, &n);
      break; }
  }
  CHECK_RESULT(ret);
  CAMLreturn(Val_unit);
}
