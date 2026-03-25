# 🎮 Proyecto: Modernización de Gunbound - Resumen Ejecutivo

**Fecha de creación**: 26 de febrero de 2026  
**Estado**: Planificación & Diseño Arquitectónico  
**Objetivo**: Modernizar Gunbound (juego legacy de Softnix) con tech stack moderno y mantenible

---

## 📋 Resumen del Proyecto

### ¿Qué es Gunbound?
- **Juego**: Gunbound (Softnix, 2002)
- **Género**: Estrategia por turnos, multijugador online
- **Mecánica**: Similar a Worms - controlar avatares, apuntar ángulo/potencia, considerar terreno
- **Estado actual**: Servidor activo en `13.248.251.57:8625`
- **Versión cliente instalable**: v2.1.5 (con launcher Electron moderno)

### Tech Stack Actual de Gunbound (Analizado)
```
Cliente Principal: gunbound.exe (C++ + DirectX 8/9)
├─ Gráficos: DirectX (D3D8, D3D9, DDraw)
├─ Compatibilidad: Vulkan + OpenGL ES (libGLESv2, vk_swiftshader)
├─ Capas compat: dxwnd, DDrawCompat, dgVoodoo
└─ Recursos: Formato propietario .xfs (avatar, sound, graphics)

Launcher: Electron (Node.js + HTML/CSS/JS)
├─ Versión: v2.1.5
└─ Empaquetado en: app.asar

Servidor: Desconocido (probablemente C++ o Java legacy)
└─ Conexión: TCP/IP a 13.248.251.57:8625 y buddy server :8626

Anti-cheat: SARD (sard_1.0.1.32.sys)
```

---

## 🎯 Tech Stack Propuesto (MODERNIZADO)

### **FRONTEND: Angular + TypeScript**
```
Tecnologías:
├─ Framework: Angular 18+ (versión actual/LTS)
├─ Lenguaje: TypeScript
├─ Bundler: Webpack (integrado en Angular)
├─ Gráficos 3D: Three.js o Babylon.js
├─ Styling: SCSS/TailwindCSS
├─ State Management: NgRx o Signals (nuevo)
├─ HTTP/WebSocket: RxJS + Socket.io-client o nativo
├─ Testing: Jasmine + Karma
└─ Build: Angular CLI

Razones Angular:
✅ Excelente para aplicaciones complejas
✅ Fuertemente tipado end-to-end
✅ RouterModule integrado
✅ RxJS para manejo reactivo de eventos de juego
✅ Testing robusto nativo
✅ Escalable para datos en tiempo real (multiplayer)
✅ Buena documentación y comunidad enterprise
```

### **BACKEND: C# + ASP.NET Core**
```
Tecnologías:
├─ Runtime: .NET 9 (o LTS 8)
├─ Framework: ASP.NET Core
├─ WebSocket/Tiempo Real: SignalR
├─ API: Minimal APIs o Controllers
├─ ORM: Entity Framework Core
├─ Base de datos: PostgreSQL
├─ Cache: Redis
├─ Validación: FluentValidation
├─ Logging: Serilog
├─ Pattern: CQRS con MediatR
├─ Testing: xUnit + NSubstitute
└─ DI: Autofac o built-in

Razones C#:
✅ Alto rendimiento (comparable a Go/Rust)
✅ Async/await nativo para I/O
✅ SignalR: WebSocket + fallbacks automáticos
✅ Ecosistema gaming (Microsoft + comunidad)
✅ Fuertemente tipado
✅ Escalable con Kubernetes
✅ Entity Framework: ORM robusto para PostgreSQL
```

### **BASE DE DATOS**
```
PostgreSQL (Relacional)
├─ Usuarios (credenciales, stats, perfil)
├─ Inventario (avatares, armas, items)
├─ Partidas (historial, replays)
├─ Elo/Ranking
└─ Chat/Amigos

Redis (Cache/Sesiones)
├─ Sesiones activas
├─ Estado de jugadores en lobby
├─ Matchmaking queue
└─ Caché de datos frecuentes
```

### **INFRAESTRUCTURA & DevOps**
```
Contenedores:
├─ Docker (desarrollo y producción)
└─ Docker Compose (orquestación local)

Orquestación:
├─ Kubernetes (producción)
├─ Auto-scaling para game servers
└─ Load balancing (Nginx/HAProxy)

CI/CD:
├─ GitHub Actions
├─ Automated testing en cada push
└─ Automated deployments

Monitoreo:
├─ Prometheus (métricas)
├─ Grafana (dashboards)
├─ ELK Stack (logs)
└─ Alerting

Cloud/Hosting:
├─ AWS, GCP o Azure
├─ Instancias auto-escalables
└─ CDN para assets
```

---

## 🏗️ Arquitectura de Gameplay

### **Flujo de Comunicación (Turnos)**
```
Cliente (Angular + Three.js)
    ↓
    Cliente calcula:
    - Ángulo del arma
    - Potencia
    - Selecciona arma
    ↓
SignalR WebSocket → Backend (C# + SignalR Hub)
    ↓
    Servidor valida:
    - ¿Es turno del jugador?
    - ¿Ángulo/potencia válidos?
    - ¿Arma disponible?
    - Anti-cheat checks
    ↓
    Servidor ejecuta física del disparo:
    - Calcula trayectoria
    - Simula colisiones
    - Calcula daño
    - Actualiza estado del mapa
    ↓
SignalR Broadcast → Todos los clientes en la partida
    ↓
Clientes animan resultado:
    - Trayectoria del proyectil
    - Explosión
    - Daño
    - Actualizar UI del mapa
```

### **Salas de Juego (Match Instances)**
```
Cada partida es una instancia independiente:
├─ GameRoom { Id, Players[], GameState, Physics }
├─ Turn Manager { CurrentPlayer, TimeLimit, Actions[] }
├─ Physics Engine { Terrain, Damage Calc, Hitboxes }
└─ Replay System { Record actions, Allow replay watching }

Cada GameRoom corre en su propia conexión SignalR
Max 4 jugadores por sala (configurable)
```

---

## 📁 Estructura de Directorios Propuesta

```
root/
├─ frontend/                          # Aplicación Angular
│  ├─ src/
│  │  ├─ app/
│  │  │  ├─ core/                     # Servicios singleton (Auth, API)
│  │  │  ├─ shared/                   # Componentes compartidos
│  │  │  ├─ features/
│  │  │  │  ├─ auth/                  # Login, registro
│  │  │  │  ├─ lobby/                 # Sala de espera, matchmaking
│  │  │  │  ├─ game/                  # Gameplay, UI de batalla
│  │  │  │  ├─ inventory/             # Avatares, armas, items
│  │  │  │  └─ profile/               # Perfil de usuario, estadísticas
│  │  │  └─ store/                    # NgRx/Signals state management
│  │  ├─ assets/
│  │  └─ environments/
│  ├─ angular.json
│  ├─ tsconfig.json
│  └─ package.json
│
├─ backend/                           # API C# + SignalR
│  ├─ src/
│  │  ├─ GunboundAPI/
│  │  │  ├─ Controllers/              # REST endpoints
│  │  │  ├─ Hubs/                     # SignalR Game Hubs
│  │  │  ├─ Services/                 # Lógica de negocio
│  │  │  ├─ Models/                   # Entidades DbContext
│  │  │  ├─ DTOs/                     # Data Transfer Objects
│  │  │  ├─ Validators/               # FluentValidation
│  │  │  ├─ Middleware/               # Auth, logging, etc
│  │  │  ├─ Data/
│  │  │  │  ├─ GunboundDbContext.cs
│  │  │  │  └─ Migrations/
│  │  │  └─ Program.cs                # Configuración DI
│  │  └─ GunboundAPI.Tests/           # Tests xUnit
│  ├─ Dockerfile
│  └─ .csproj
│
├─ docker-compose.yml                 # PostgreSQL, Redis, Backend
├─ kubernetes/                        # Manifests para K8s
│  ├─ deployment.yaml
│  ├─ service.yaml
│  └─ ingress.yaml
│
├─ .github/
│  └─ workflows/
│     ├─ frontend-ci.yml
│     └─ backend-ci.yml
│
└─ README.md
```

---

## 🔗 Protocolo de Mensajes SignalR

### **Eventos Cliente → Servidor**
```csharp
// Entrar a partida
emit('JoinGame', { gameId: string, playerId: string })

// Acción de turno
emit('ExecuteTurn', { 
    angle: number,
    power: number,
    weaponId: string,
    targetCoords?: { x, y }
})

// Chat
emit('SendMessage', { message: string })

// Abandonar partida
emit('LeaveGame', { gameId: string })
```

### **Eventos Servidor → Cliente**
```csharp
// Actualización de estado
broadcast('GameStateUpdated', {
    gameState: GameState,
    currentPlayer: Player,
    timeRemaining: number
})

// Resultado de turno
broadcast('TurnExecuted', {
    playerId: string,
    result: {
        damage: number,
        hitPos: { x, y },
        explosionRadius: number,
        affectedPlayers: Player[]
    }
})

// Cambio de turno
broadcast('TurnChanged', {
    currentPlayerId: string,
    timeLimit: number
})

// Fin de partida
broadcast('GameEnded', {
    winner: Player,
    stats: PlayerStats,
    rewards: Rewards
})
```

---

## 🎮 Características Clave del Nuevo Sistema

### **Gameplay**
- ✅ Turnos sincronizados (validación servidor-side 100%)
- ✅ Física del proyectil calculada en servidor
- ✅ Anti-cheat integrado (detección de anomalías)
- ✅ Sistema de replay (guardar y reproducir partidas)
- ✅ Matchmaking automático (ELO-based)

### **Social**
- ✅ Amigos/Bloqueados
- ✅ Salas de chat por lobby
- ✅ Sistema de clanes
- ✅ Campeonatos/Torneos

### **Economía/Progresión**
- ✅ Sistema de avatares (personajes jugables)
- ✅ Inventario de armas
- ✅ Moneda premium + soft currency
- ✅ Battle pass / Seasonal rewards
- ✅ Elo/Ranking visible

### **Monetización**
- ✅ Compras in-game (avatares, armas cosmético)
- ✅ Battle pass (cosmético)
- ✅ Pases de batalla (generador de ingresos)
- ✅ Bundles temáticos

---

## 📊 Comparativa: Actual vs Modernizado

| Aspecto | Gunbound Original | Versión Modernizada |
|---------|-------------------|---------------------|
| **Cliente** | C++ DirectX (legacy) | Angular + Three.js (web) |
| **Servidor** | C++/Java (unknown) | C# .NET + SignalR |
| **Platform** | Windows solo | Web + Mobile (responsive) |
| **Escalabilidad** | Baja | Alta (Kubernetes) |
| **Mantenibilidad** | Difícil (legacy) | Fácil (moderno) |
| **Tiempo desarrollo** | Lento | Rápido (TS + frameworks) |
| **DevOps** | Desconocido | Docker + GitHub Actions |
| **Monitoreo** | Manual | Prometheus + ELK |
| **Anti-cheat** | SARD (kernel) | Detección heurística servidor |
| **Instalación** | Installer EXE | Solo navegador |

---

## 🚀 Plan de Desarrollo Sugerido (Fases)

### **Fase 1: MVP (4-6 semanas)**
- [ ] Autenticación (login/registro)
- [ ] Lobby básico
- [ ] Una arena simple con 2 jugadores
- [ ] Sistema de turnos básico
- [ ] UI gameplay mínima

### **Fase 2: MVP+ (4-6 semanas)**
- [ ] Múltiples armas
- [ ] Física realista
- [ ] Efectos visuales
- [ ] Chat
- [ ] Matchmaking simple (random)

### **Fase 3: Feature Completo (8-10 semanas)**
- [ ] Sistema de avatares
- [ ] Sistema de elo/ranking
- [ ] Inventario
- [ ] Economía de juego (currency)
- [ ] Sistema de replays

### **Fase 4: Pulido & Optimización**
- [ ] Testing exhaustivo
- [ ] Optimizaciones de rendimiento
- [ ] Localización (idiomas)
- [ ] Documentación
- [ ] Deployment producción

---

## 🔐 Consideraciones de Seguridad

1. **Validación Servidor-Side**: TODAS las acciones de juego validadas en backend
2. **JWT Tokens**: Autenticación stateless
3. **Rate Limiting**: Prevenir abuso de API
4. **DDoS Protection**: CloudFlare o similar
5. **Encryption**: HTTPS/TLS obligatorio
6. **Secrets Management**: Variables de entorno, no hardcoded
7. **SQL Injection Prevention**: Usar ORM (EF Core)
8. **CORS**: Configurar solo dominios permitidos

---

## 📈 Escalabilidad

**Estimado para 10,000 jugadores concurrentes:**
- 2,500 servidores de juego (4 jugadores máx por sala)
- Load balancer con auto-scaling
- PostgreSQL con replicación
- Redis cluster para cache
- Kubernetes con HPA (Horizontal Pod Autoscaler)

**Costo estimado**: $5,000-$15,000/mes en AWS/GCP (según región)

---

## ✅ Checklist Inicial

- [ ] Crear repositorio GitHub
- [ ] Configurar CI/CD con GitHub Actions
- [ ] Scaffold Frontend (Angular 18)
- [ ] Scaffold Backend (ASP.NET Core)
- [ ] Docker & Docker Compose setup
- [ ] Base de datos PostgreSQL local
- [ ] Primeros endpoints REST
- [ ] Primer SignalR Hub conexión
- [ ] Autenticación JWT
- [ ] Tests unitarios setup

---

## 📚 Referencias & Recursos

**Frontend (Angular)**
- https://angular.io/docs
- https://threejs.org/docs/
- https://rxjs.dev/

**Backend (C# / .NET)**
- https://learn.microsoft.com/dotnet/
- https://learn.microsoft.com/aspnet/signalr/
- https://www.entityframeworktutorial.net/

**DevOps**
- https://docs.docker.com/
- https://kubernetes.io/docs/
- https://github.com/features/actions

**Bases de Datos**
- https://www.postgresql.org/docs/
- https://redis.io/docs/

---

**Última actualización**: 26 de febrero de 2026  
**Versión documento**: 1.0  
**Responsable**: Análisis técnico para modernización de Gunbound
