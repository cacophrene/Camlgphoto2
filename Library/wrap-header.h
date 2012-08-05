// wrap-header for camlgphoto2

#define File_val(x) (CameraFile *) Int_val(Field((x), 0));
#define Camera_val(x) (Camera *) Int_val(Field((x), 0))
#define Context_val(x) (GPContext *) Int_val(Field((x), 0));
#define Abilities_val(x) (CameraAbilities *) Int_val(Field((x), 0));
#define AbilitiesList_val(x) (CameraAbilitiesList *) Int_val(Field((x), 0));
#define CHECK_RESULT(x) if ((x) < 0) caml_failwith(gp_port_result_as_string(x))
#define Widget_val(v) (CameraWidget *) Int_val(Field((v), 0))

value encapsulate_pointer(void *ptr);
value val_couples(CameraList *list);
