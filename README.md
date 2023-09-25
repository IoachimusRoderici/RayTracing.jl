# RayTracing

Esta es una simulación de un rayo de luz que rebota con un conjunto de esferas.

El objetivo original era simular la salida de un rayo de luz desde el centro del sol, pero obviamente la escala no permite simular tantos átomos, al menos con esta *approach*.

La [versión original](https://colab.research.google.com/drive/13z6Xp2l84JcSg4Ms1cRwQSZalnThA6M5?usp=sharing) estaba escrita en python y era más prolija, pero era lenta. Esta versión está escrita en C y es más rápida,
pero no está escrita de una manera muy correcta.

![Gráfico 2D mostrando el recorrido de un rayo que rebota con un grupo de círculos](/recorrido.png)
![Gráfico de la distancia recorrida por el rayo en función del radio de la estrella](/plot.png)
