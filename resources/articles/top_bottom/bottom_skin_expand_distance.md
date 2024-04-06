Расстояние расширения нижней части
====
Сделайте сплошные слои внизу отпечатка шире или тоньше в горизонтальном направлении. Обычно сплошные слои создаются только над частями, под которыми есть воздух, но с помощью этой настройки вы можете немного расширить их по горизонтали, повысив прочность, заставляя обшивку лучше прилегать к соседним стенкам и закрывая зазоры в обшивке.

<!--screenshot {
"image_path": "skin_preshrink_original.png",
"models": [{"script": "stature_symmetrical.scad"}],
"camera_position": [104, -7, 4],
"settings": {
    "wall_line_count": 0,
    "infill_wall_line_count": 1,
    "bottom_skin_preshrink": 0,
    "top_skin_preshrink": 0,
    "bottom_skin_expand_distance": 0,
    "top_skin_expand_distance": 0,
    "max_skin_angle_for_expansion": 89
},
"colours": 32
}-->
<!--screenshot {
"image_path": "expand_skins_expand_distance_1mm.png",
"models": [{"script": "stature_symmetrical.scad"}],
"camera_position": [104, -7, 4],
"settings": {
    "wall_line_count": 0,
    "infill_wall_line_count": 1,
    "bottom_skin_expand_distance": 1,
    "top_skin_expand_distance": 1,
    "max_skin_angle_for_expansion": 89
},
"colours": 32
}-->
![How skins (the yellow parts) normally look](../images/skin_preshrink_original.png)
![Skins expanded by 1mm](../images/expand_skins_expand_distance_1mm.png)

* Если у вас есть небольшие отверстия в нижних слоях кожи (отверстия, заполненные узором заполнения), установка значения немного выше закроет их. Это позволяет принтеру непрерывно печатать итоговые строки, что значительно повышает прочность.
* Если у вас нижняя сторона не находится непосредственно на рабочей пластине, под обшивкой будут стенки. Это улучшит адгезию между нижними слоями и близлежащими стенками, поскольку нижние слои будут печататься непосредственно поверх стенок.
* Установка отрицательного значения для этого параметра уменьшит ширину нижних слоев, заменив их заполнением. Это может сэкономить время печати за счет прочности.

**Из-за технических ограничений вы не можете уменьшить этот параметр ниже значения [Bottom Skin Removal Width](bottom_skin_preshrink.md). Увеличьте настройку ширины удаления нижней кожи, чтобы удалить больше кожи.**
