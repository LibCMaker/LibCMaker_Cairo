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


/* png frontend for cairo_snippets
 * (c) Øyvind Kolås 2004, placed in the public domain
 */

#include "snippets.h"

#define IMAGE_WIDTH  512
#define IMAGE_HEIGHT 512

#define LINE_WIDTH 0.04

/* process a snippet, writing it out to file */
static void
snippet_do_png (int no);

int
maintest (void)
{
  int i;

  for (i = 0; i < snippet_count; i++)
    snippet_do_png (i);

  return 0;
}

static void
snippet_do_png (int no)
{
        cairo_t *cr;
  cairo_surface_t *surface;
        char filename[1024];

        fprintf (stdout, "processing %s", snippet_name[no]);

  surface = cairo_image_surface_create (CAIRO_FORMAT_ARGB32,
                IMAGE_WIDTH, IMAGE_HEIGHT);
        cr = cairo_create (surface);

        cairo_save (cr);
          snippet_do (cr, no, IMAGE_WIDTH, IMAGE_HEIGHT);
        cairo_restore (cr);

        sprintf (filename, "%s.png", snippet_name [no]);
  cairo_surface_write_to_png (surface, filename);

        fprintf (stdout, "\n");

        cairo_destroy (cr);
  cairo_surface_destroy (surface);
}
