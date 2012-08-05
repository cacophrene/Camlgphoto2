(* gPAbilities.mli - This file is part of the camlgphoto2 library
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

(** Camera abilities. *)

type t
(** The type of camera abilities. *)

type driver_status =
  | GP_DRIVER_STATUS_PRODUCTION   (** Driver is production ready. *)
  | GP_DRIVER_STATUS_TESTING      (** Driver is beta quality. *)
  | GP_DRIVER_STATUS_EXPERIMENTAL (** Driver is alpha quality and might even not work. *)
  | GP_DRIVER_STATUS_DEPRECATED   (** Driver is not recommended and will be removed. *)
(** Current implementation status of the camera driver. *)

val get_status : t -> driver_status
(** @return the driver status. *)

type device_type = 
  | GP_DEVICE_TYPE_STILL_CAMERA   (** Traditional still camera. *)
  | GP_DEVICE_TYPE_AUDIO_PLAYER   (** MTP audio player. *)
(** Type of the device represented. *)

val get_device_type : t -> device_type
(** @return the device type. *)

type camera_operation =
  | CO_CAPTURE_IMAGE    (** The camera can capture images. *)
  | CO_CAPTURE_VIDEO    (** The camera can capture videos. *)
  | CO_CAPTURE_AUDIO    (** The camera can capture audio. *)
  | CO_CAPTURE_PREVIEW  (** Capturing image previews is supported. *)
  | CO_CONFIG           (** Camera and driver configuration are supported. *)
(** Remote control related operations of the device. *)

type camera_file_operation =
  | FO_DELETE       (** Deletion of files is possible. *)
  | FO_PREVIEW      (** Previewing viewfinder content is possible. *)
  | FO_RAW          (** Raw retrieval is possible (non-JPEG cameras). *)
  | FO_AUDIO        (** Audio retrieval is possible. *)
  | FO_EXIF         (** EXIF retrieval is possible. *)
(** Image related operations of the device. *)

type camera_directory_operation =
  | DO_DELETE_ALL   (** Deletion of all files on the device. *)
  | DO_PUT_FILE     (** Upload of files to the device possible. *)
  | DO_MAKE_DIR     (** Making directories on the device possible. *)
  | DO_REMOVE_DIR   (** Removing directories from the device possible. *)
(** Filesystem related operations of the device. *)
