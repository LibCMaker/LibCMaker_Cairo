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


/* interface to autogenerated snippets.c file */
/* cairo_snippets (c) Øyvind Kolås 2004, released to the public domain */

#ifndef SNIPPETS_H
#define SNIPPETS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cairo.h>

/* header files available for snippet usage */

#include <math.h>

/* number of available snippets */
extern int snippet_count;

/* the basename of the snippets */
extern const char *snippet_name[];

/* run a snippet */
void
snippet_do (cairo_t *cr,
            int      snippet_no,
            int      width,
            int      height);

/* utility function mapping a snippet name to a snippet number */
int
snippet_name2no (const char *name);

/* normalize the coordinate system of the cairo drawable to a unit square,
 * also sets the line width to 0.04
 */
void
snippet_normalize (cairo_t *cr,
                   double   width,
                   double   height);

void
snippet_set_bg_png (cairo_t *cr, const char *file);

#endif /* SNIPPETS_H */