function [ FEN ] = checkersToFEN( pieces, turn )
% Converts the pieces array into FEN notation for use in Checkerboard
% Turn is a character (either, R or B) that indicates who's turn it is
%
% Example pieces structure
% p = pieces(1)
% color = p(1)
% row = p(2)
% col = p(3)
%
% Example FEN for starting board
% B:W32,31,30,29,28,27,26,25,24,23,22,21:B12,11,10,9,8,7,6,5,4,3,2,1.

black = pieces(:, 1) == 0;
red = pieces(:, 1) == 1;

% Explain this
FENblack = (pieces(black, 2) - 1) * 4 + floor(pieces(black, 3)/2) + (mod(pieces(black, 2), 2) == 0);
FENred = (pieces(red, 2) - 1) * 4 + floor(pieces(red, 3)/2) + (mod(pieces(red, 2), 2) == 0); 


% Convert to FEN and copy to clipboard
FEN = regexprep([turn ':W' num2str(FENblack') ':B' num2str(FENred') '.'], '[\s]*', ',');
clipboard('copy', FEN);

end

