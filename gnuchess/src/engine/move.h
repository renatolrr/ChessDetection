/* move.h

   GNU Chess engine

   Copyright (C) 2001-2011 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


// move.h

#ifndef MOVE_H
#define MOVE_H

// includes

#include "board.h"
#include "util.h"

namespace engine {

// constants

const int MoveNone = 0;  // HACK: a1a1 cannot be a legal move
const int MoveNull = 11; // HACK: a1d2 cannot be a legal move

const int MoveNormal    = 0 << 14;
const int MoveCastle    = 1 << 14;
const int MovePromote   = 2 << 14;
const int MoveEnPassant = 3 << 14;
const int MoveFlags     = 3 << 14;

const int MovePromoteKnight = MovePromote | (0 << 12);
const int MovePromoteBishop = MovePromote | (1 << 12);
const int MovePromoteRook   = MovePromote | (2 << 12);
const int MovePromoteQueen  = MovePromote | (3 << 12);

const int MoveAllFlags = 0xF << 12;

const char NullMoveString[] = "null"; // "0000" in UCI

// macros

#define MOVE_MAKE(from,to)             ((SQUARE_TO_64(from)<<6)|SQUARE_TO_64(to))
#define MOVE_MAKE_FLAGS(from,to,flags) ((SQUARE_TO_64(from)<<6)|SQUARE_TO_64(to)|(flags))

#define MOVE_FROM(move)                (SQUARE_FROM_64(((move)>>6)&077))
#define MOVE_TO(move)                  (SQUARE_FROM_64((move)&077))

#define MOVE_IS_SPECIAL(move)          (((move)&MoveFlags)!=MoveNormal)
#define MOVE_IS_PROMOTE(move)          (((move)&MoveFlags)==MovePromote)
#define MOVE_IS_EN_PASSANT(move)       (((move)&MoveFlags)==MoveEnPassant)
#define MOVE_IS_CASTLE(move)           (((move)&MoveFlags)==MoveCastle)

#define MOVE_PIECE(move,board)         ((board)->square[MOVE_FROM(move)])

// types

typedef uint16 mv_t;

// functions

extern bool move_is_ok            (int move);

extern int  move_promote          (int move);

extern int  move_order            (int move);

extern bool move_is_capture       (int move, const board_t * board);
extern bool move_is_under_promote (int move);
extern bool move_is_tactical      (int move, const board_t * board);

extern int  move_capture          (int move, const board_t * board);

extern bool move_to_string        (int move, char string[], int size);
extern int  move_from_string      (const char string[], const board_t * board);

}  // namespace engine

#endif // !defined MOVE_H

// end of move.h

