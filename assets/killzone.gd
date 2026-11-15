var player1=0
var player2=0
extends Area2D

while true:
	if position.x>=68.3:
		player1+1
		print("player1 now has "player1"points!")
	if position.x<=-67.1:
		player2+1
		print("player two now has"player2" points!")
	
