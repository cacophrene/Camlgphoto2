(* gPContext.mli - This file is part of the camlgphoto2 library
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

(** Context-related functions. *)

type t
(** The gphoto context structure. This structure allows callback handling, 
  * passing error contexts back, progress handling and download cancellation and
  * similar things. It is usually passed around the functions. *)

val create : unit -> t
(** Creates a new context. *)


(** {2 Reference counting} *)

val incr_ref : t -> unit
(** Increments the reference count of the context. *)

val decr_ref : t -> unit
(** Decrements the reference count of the context and frees if it goes to 0. *)
