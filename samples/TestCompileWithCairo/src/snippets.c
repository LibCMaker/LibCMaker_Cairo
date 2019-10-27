/*****************************************************************************
 * Project:  LibCMaker_Cairo
 * Purpose:  A CMake build script for Cairo library
 * Author:   NikitaFeodonit, nfeodonit@yandex.com
 *****************************************************************************
 *   Copyright (c) 2017-2019 NikitaFeodonit
 *
 *    This file is part of the LibCMaker_Cairo project.
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published
 *    by the Free Software Foundation, either version 3 of the License,
 *    or (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *    See the GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program. If not, see <http://www.gnu.org/licenses/>.
 ****************************************************************************/

/*
  The code is from
  https://gitlab.com/cairo/cairo-demos/tree/master/cairo_snippets
*/


/* DO NOT EDIT!, file autogenerated by prepare_snippets, using *.cairo files */
#include "snippets.h"


int snippet_count=1;

const char *snippet_name[2]={
"text_align_center",
NULL
};


void
snippet_do (cairo_t *cr, int snippet_no, int width, int height)
{
   switch (snippet_no) {

     case 0:{ /* text_align_center */


cairo_text_extents_t extents;

const char *utf8 = "cairo_iiiiiiiiiii_30/07/2018";
double x,y;

snippet_normalize (cr, width, height);

cairo_set_source_rgba (cr, 1, 1, 1, 1);
cairo_rectangle (cr, 0, 0, 1, 1);
cairo_fill (cr);

cairo_set_source_rgba (cr, 0, 0, 0, 1);

cairo_select_font_face (cr, "Sans",
    CAIRO_FONT_SLANT_NORMAL,
    CAIRO_FONT_WEIGHT_NORMAL);

cairo_set_font_size (cr, 0.05);
cairo_text_extents (cr, utf8, &extents);
/*
x = 0.5 - (extents.width / 2 + extents.x_bearing);
y = 0.5 - (extents.height / 2 + extents.y_bearing);
*/
x = 0.3;
y = 0.3;

cairo_move_to (cr, x, y);
cairo_show_text (cr, utf8);

/* draw helping lines */
cairo_set_source_rgba (cr, 1, 0.2, 0.2, 0.6);
cairo_arc (cr, x, y, 0.05, 0, 2*M_PI);
cairo_fill (cr);
cairo_move_to (cr, 0.5, 0);
cairo_rel_line_to (cr, 0, 1);
cairo_move_to (cr, 0, 0.5);
cairo_rel_line_to (cr, 1, 0);
cairo_stroke (cr);


             }break;
     default:
       fprintf (stderr, "do_snippet: snippet_no %i, out of range\n", snippet_no);
   }
}
int
snippet_name2no (const char *name)
{
        int i;
        for (i=0;i<snippet_count;i++)
                if (!strcmp(name, snippet_name[i]))
                        return i;
        fprintf (stderr, "snippet_name2no: by name '%s' not found\n", name);
        return -1;
}
void
snippet_set_bg_png (cairo_t *cr, const char *file)
{
   int w,h;
   cairo_surface_t *image;
   image = cairo_image_surface_create_from_png (file);
   w = cairo_image_surface_get_width (image);
   h = cairo_image_surface_get_height (image);
   cairo_save (cr);
       cairo_scale (cr, 1.0/w, 1.0/h);
       cairo_set_source_surface (cr, image, 0, 0);
       cairo_paint (cr);
   cairo_restore (cr);
   cairo_surface_destroy (image);
}
void
snippet_normalize (cairo_t *cr, double width, double height)
{
    cairo_scale (cr, width, height);
    cairo_set_line_width (cr, 0.04);
}
