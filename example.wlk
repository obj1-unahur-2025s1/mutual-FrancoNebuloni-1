class Viajes {
  const idiomas = {"español"}

  method implicaEsfuerzo() = false
  method sirveParaBroncearse() = false
  method cantidadDiasDeLaActividad() = 0
  method idiomasUsados() = idiomas
  method cambiarIdioma(unIdioma) {
    idiomas.add(unIdioma)
  }
  method esInteresante() = idiomas.size() > 1
  method seRecomiendaA(unSocio) = self.esInteresante()
  && 
  unSocio.leAtrae(self) 
  && 
  not unSocio.actividadesRealizadas().contains(self)
}

class ViajesDePlaya inherits Viajes{
  var property largo

  override method cantidadDiasDeLaActividad() = (largo / 500).max(0)
  override method implicaEsfuerzo() = largo > 1200
  override method sirveParaBroncearse() = true
}

class ExcursionesACiudad inherits Viajes{
  var property cantidadAtracciones

  override method cantidadDiasDeLaActividad() = cantidadAtracciones / 2
  override method implicaEsfuerzo() = cantidadAtracciones.between(5, 8)
  override method sirveParaBroncearse() = false
  override method esInteresante() = super() or cantidadAtracciones == 5
}

class ExcursionesACiudadTropical inherits ExcursionesACiudad {
  override method cantidadDiasDeLaActividad() = super() + 1
  override method sirveParaBroncearse() = true
}

class SalidaDeTrekking inherits Viajes {
  var property kmSendero 
  var property diasDeSol

  override method cantidadDiasDeLaActividad() = kmSendero / 50
  override method implicaEsfuerzo() = kmSendero > 80
  override method sirveParaBroncearse() = diasDeSol > 200 or diasDeSol.between(100, 200) && kmSendero > 120
  override method esInteresante() = super() && diasDeSol > 140
}

class ClasesDeGimnasia inherits Viajes{
  override method idiomasUsados() = ["Español"]
  override method cantidadDiasDeLaActividad() = 1
  override method implicaEsfuerzo() = true
  override method sirveParaBroncearse() = false
  override method seRecomiendaA(unSocio) = unSocio.edad().between(20, 30)
}

class Socios {
  const actividadesRealizadas = []
  var cantMaxAct = 0
  const idiomasQueHabla = []
  var edad = 0
  var property tipoDeSocio = socioTranquilo

  method esAdoradorDelSol() = actividadesRealizadas.all({a => a.sirveParaBroncearse()})
  method coleccionActEsforzadas() = actividadesRealizadas.filter({a => a.implicaEsfuerzo()})
  method registrarAct(unaActividad) {
    if(actividadesRealizadas.size() < cantMaxAct) {
      actividadesRealizadas.add(unaActividad)
    }
    else {
      self.error("Se alcanzó el maximo de actividades para este socio")
    }
  } 
  method leAtrae(unaActividad) = tipoDeSocio.leGusta(unaActividad)
  method idiomasQueHabla() = idiomasQueHabla
  method esRecomendada(unaActividad) = unaActividad.seRecomiendaA(self)
  method edad() = edad
}

object socioTranquilo inherits Socios {
  method leGusta(unaActividad) = unaActividad.cantidadDiasDeLaActividad() >= 4
}

object socioCoherente inherits Socios {
  method leGusta(unaActividad) = if(self.esAdoradorDelSol()) {
    return unaActividad.sirveParaBroncearse()
  } else {
    return unaActividad.implicaEsfuerzo()
  }
}

object socioRelajado inherits Socios {
  method leGusta(unaActividad) = self.idiomasQueHabla().contains(unaActividad.idioma()) 
}

class TallerLiterario inherits Viajes{
  const librosTrabajados = []

  method agregarLibro(unLibro) {
    librosTrabajados.add(unLibro)
  }
  override method idiomasUsados() = librosTrabajados.map({l => l.idioma()}).distinct()
  method diasQueLleva() = librosTrabajados.size() + 1
  override method implicaEsfuerzo() = librosTrabajados.any({l => l.cantidadPaginas() > 500}) 
  or (librosTrabajados.map({l => l.autor()}).distinct().size() > 1)
  override method sirveParaBroncearse() = false
  override method seRecomiendaA(unSocio) = unSocio.idiomasQueHabla().size() > 1
}

class Libros {
  var property idioma
  var property cantidadPaginas 
  var property autor
}