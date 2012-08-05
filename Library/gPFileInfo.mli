(* gPFileInfo.mli - This file is part of the camlgphoto2 library
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

type file_type = 
  | GP_FILE_TYPE_PREVIEW        (** Preview file. *)
  | GP_FILE_TYPE_NORMAL         (** Normal file.  *)
  | GP_FILE_TYPE_RAW            (** Raw data.     *)
  | GP_FILE_TYPE_AUDIO          (** Audio file.   *)
  | GP_FILE_TYPE_EXIF
  | GP_FILE_TYPE_METADATA
(** The type of camera files. *)

type file_permissions =
  | GP_FILE_PERM_NONE           (** No permissions.   *)
  | GP_FILE_PERM_READ           (** Read permission.  *)
  | GP_FILE_PERM_DELETE         (** Write permission. *)
(** File permissions. *)
