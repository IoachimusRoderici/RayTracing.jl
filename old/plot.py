'''
Este programa es para hacer gráficos de la simulación.

Hay que pasar como primer argumento un archivo con los centros,
como segundo argumento el radio de los cuerpos, y (opcional) 
como tercer argumento un archivo con el recorrido.
'''

import sys
import numpy as np
from matplotlib import pyplot as plt

def mostrar_cuerpos2D(fig, cuerpos, radio_cuerpo):
  '''
  Agrega a la figura un axes con el scatterplot de todos los
  cuerpos y la devuelve.
  '''
  ax=fig.add_subplot()

  R = np.max(np.linalg.norm(cuerpos,axis=1))
  viewport = -R*1.1, R*1.1
  ax.set_xlim(*viewport)
  ax.set_ylim(*viewport)
  ax.set_aspect(1)
  ax.axis('off')

  for cuerpo in cuerpos:
    ax.add_artist(plt.Circle(cuerpo,radio_cuerpo, zorder=10))

  return ax

def agregar_recorrido(ax, recorrido):
  '''
  Recibe el ax con el sol, y le agrega el recorrido del rayo.
  Devuelve el objeto Line2D.
  '''

  return ax.plot([punto[0] for punto in recorrido], [punto[1] for punto in recorrido], c='r', linewidth=1)[0]

'''
USO:
fig = plt.figure(figsize=(7,7))
ax = mostrar_cuerpos2D(fig, centros, radio_cuerpo)
rec = agregar_recorrido(ax, recorrido)
'''

if len (sys.argv) < 3:
  print("Error: no hay suficientes argumentos.")
  quit()
elif len (sys.argv) > 4:
  print("Error: hay demasiados argumentos.")
  quit()

centros = np.loadtxt(sys.argv[1])
radio_cuerpo = float(sys.argv[2])

fig = plt.figure(figsize=(7,7))
ax = mostrar_cuerpos2D(fig, centros, radio_cuerpo)

if len (sys.argv) == 4:
  recorrido = np.loadtxt(sys.argv[3])
  rec = agregar_recorrido(ax, recorrido)

plt.show()