(* gPAbilities.ml - This file is part of the camlgphoto2 library
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
 *)

type t

type driver_status =
  | GP_DRIVER_STATUS_PRODUCTION
  | GP_DRIVER_STATUS_TESTING
  | GP_DRIVER_STATUS_EXPERIMENTAL
  | GP_DRIVER_STATUS_DEPRECATED

external get_status : t -> driver_status
  = "caml_gp_abilities_get_status" 

type device_type = 
  | GP_DEVICE_TYPE_STILL_CAMERA
  | GP_DEVICE_TYPE_AUDIO_PLAYER  
  
external get_device_type : t -> device_type
  = "caml_gp_abilities_get_device_type" 
  
type camera_operation =
  | CO_CAPTURE_IMAGE
  | CO_CAPTURE_VIDEO
  | CO_CAPTURE_AUDIO
  | CO_CAPTURE_PREVIEW
  | CO_CONFIG

type camera_file_operation =
  | FO_DELETE
  | FO_PREVIEW
  | FO_RAW
  | FO_AUDIO
  | FO_EXIF

type camera_directory_operation =
  | DO_DELETE_ALL
  | DO_PUT_FILE
  | DO_MAKE_DIR
  | DO_REMOVE_DIR
  

