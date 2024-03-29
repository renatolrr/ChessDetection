/* move.cpp

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


// move.cpp

// includes

#include <cctype>
#include <cstring>

#include "attack.h"
#include "colour.h"
#include "list.h"
#include "move.h"
#include "move_do.h"
#include "move_gen.h"
#include "piece.h"
#include "square.h"
#include "util.h"

namespace engine {

// constants

static const int PromotePiece[4] = { Knight64, Bishop64, Rook64, Queen64 };

// functions

// move_is_ok()

bool move_is_ok(int move) {

   if (move < 0 || move >= 65536) return false;

   if (move == MoveNone) return false;
   if (move == MoveNull) return false;

   return true;
}

// move_promote()

int move_promote(int move) {

   int code, piece;

   ASSERT(move_is_ok(move));

   ASSERT(MOVE_IS_PROMOTE(move));

   code = (move >> 12) & 3;
   piece = PromotePiece[code];

   if (SQUARE_RANK(MOVE_TO(move)) == Rank8) {
      piece |= WhiteFlag;
   } else {
      ASSERT(SQUARE_RANK(MOVE_TO(move))==Rank1);
      piece |= BlackFlag;
   }

   ASSERT(piece_is_ok(piece));

   return piece;
}

// move_order()

int move_order(int move) {

   ASSERT(move_is_ok(move));

   return ((move & 07777) << 2) | ((move >> 12) & 3);
}

// move_is_capture()

bool move_is_capture(int move, const board_t * board) {

   ASSERT(move_is_ok(move));
   ASSERT(board!=NULL);

   return MOVE_IS_EN_PASSANT(move) || board->square[MOVE_TO(move)] != Empty;
}

// move_is_under_promote()

bool move_is_under_promote(int move) {

   ASSERT(move_is_ok(move));

   return MOVE_IS_PROMOTE(move) && (move & MoveAllFlags) != MovePromoteQueen;
}

// move_is_tactical()

bool move_is_tactical(int move, const board_t * board) {

   ASSERT(move_is_ok(move));
   ASSERT(board!=NULL);

   return (move & (1 << 15)) != 0 || board->square[MOVE_TO(move)] != Empty; // HACK
}

// move_capture()

int move_capture(int move, const board_t * board) {

   ASSERT(move_is_ok(move));
   ASSERT(board!=NULL);

   if (MOVE_IS_EN_PASSANT(move)) {
      return PAWN_OPP(board->square[MOVE_FROM(move)]);
   }

   return board->square[MOVE_TO(move)];
}

// move_to_string()

bool move_to_string(int move, char string[], int size) {

   ASSERT(move==MoveNull||move_is_ok(move));
   ASSERT(string!=NULL);
   ASSERT(size>=6);

   if (size < 6) return false;

   // null move

   if (move == MoveNull) {
      strcpy(string,NullMoveString);
      return true;
   }

   // normal moves

   square_to_string(MOVE_FROM(move),&string[0],3);
   square_to_string(MOVE_TO(move),&string[2],3);
   ASSERT(strlen(string)==4);

   // promotes

   if (MOVE_IS_PROMOTE(move)) {
      string[4] = tolower(piece_to_char(move_promote(move)));
      string[5] = '\0';
   }

   return true;
}

// move_from_string()

int move_from_string(const char string[], const board_t * board) {

   char tmp_string[3];
   int from, to;
   int move;
   int piece, delta;

   ASSERT(string!=NULL);
   ASSERT(board!=NULL);

   // from

   tmp_string[0] = string[0];
   tmp_string[1] = string[1];
   tmp_string[2] = '\0';

   from = square_from_string(tmp_string);
   if (from == SquareNone) return MoveNone;

   // to

   tmp_string[0] = string[2];
   tmp_string[1] = string[3];
   tmp_string[2] = '\0';

   to = square_from_string(tmp_string);
   if (to == SquareNone) return MoveNone;

   move = MOVE_MAKE(from,to);

   // promote

   switch (string[4]) {
   case '\0': // not a promotion
      break;
   case 'n':
      move |= MovePromoteKnight;
      break;
   case 'b':
      move |= MovePromoteBishop;
      break;
   case 'r':
      move |= MovePromoteRook;
      break;
   case 'q':
      move |= MovePromoteQueen;
      break;
   default:
      return MoveNone;
   }

   // flags

   piece = board->square[from];

   if (PIECE_IS_PAWN(piece)) {
      if (to == board->ep_square) move |= MoveEnPassant;
   } else if (PIECE_IS_KING(piece)) {
      delta = to - from;
      if (delta == +2 || delta == -2) move |= MoveCastle;
   }

   return move;
}

}  // namespace engine

// end of move.cpp

