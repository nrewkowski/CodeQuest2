/*
Copyright (c) 2015, Joe Wingbermuehle
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
* Neither the name of the <organization> nor the
names of its contributors may be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Joe Wingbermuehle BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation

///Generates mazes
class Maze {
	
	enum Cell {
		case Space, Wall
	}
	
	var data: [[Cell]] = []
	
	// Generate a random maze.
	init(width: Int, height: Int) {
		for i in 0 ..< height {
			data.append([Cell](repeating: Cell.Wall, count: width))
		}
		for i in 0 ..< width {
			data[0][i] = Cell.Space
			data[height - 1][i] = Cell.Space
		}
		for i in 0 ..< height {
			data[i][0] = Cell.Space
			data[i][width - 1] = Cell.Space
		}
		data[2][2] = Cell.Space
		self.carve(x: 2, y: 2)
		data[1][2] = Cell.Space
		data[height - 2][width - 3] = Cell.Space
	}
	
	// Carve starting at x, y.
	func carve(x: Int, y: Int) {
		let upx = [1, -1, 0, 0]
		let upy = [0, 0, 1, -1]
		var dir = Int(arc4random_uniform(4))
		var count = 0
		while count < 4 {
			let x1 = x + upx[dir]
			let y1 = y + upy[dir]
			let x2 = x1 + upx[dir]
			let y2 = y1 + upy[dir]
			if data[y1][x1] == Cell.Wall && data[y2][x2] == Cell.Wall {
				data[y1][x1] = Cell.Space
				data[y2][x2] = Cell.Space
				carve(x: x2, y: y2)
			} else {
				dir = (dir + 1) % 4
				count += 1
			}
		}
	}
	

	
}
