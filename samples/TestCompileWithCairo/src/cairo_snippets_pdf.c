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


/* pdf frontend for cairo_snippets
 * (c) Øyvind Kolås 2004, placed in the public domain
 */

#include "snippets.h"
#include <cairo-pdf.h>

#define X_INCHES 2
#define Y_INCHES 2

#define WIDTH    X_INCHES * 72.0
#define HEIGHT   Y_INCHES * 72.0

/* add a page with the specified snippet to the output pdf file */
static void
write_page (cairo_t *cr,
            int      no);

int
main (int argc, char *argv[])
{
        int i;
  cairo_surface_t *surface;
        cairo_t *cr;

  surface = cairo_pdf_surface_create ("snippets.pdf", WIDTH, HEIGHT);
        cr = cairo_create (surface);

  if (argc == 1) {
    for (i = 0; i < snippet_count; i++)
      write_page (cr, i);
  }
  else {
    for (i = 1; i < argc; i++)
      write_page (cr, atoi (argv[i]));
  }

        cairo_destroy (cr);
        cairo_surface_destroy (surface);

        return 0;
}

static void
write_page (cairo_t *cr,
            int      no)
{
        fprintf (stdout, "processing %s", snippet_name[no]);

        cairo_save (cr);
          snippet_do (cr, no, WIDTH, HEIGHT);
          cairo_show_page (cr);
        cairo_restore (cr);

        fprintf (stdout, "\n");
}
