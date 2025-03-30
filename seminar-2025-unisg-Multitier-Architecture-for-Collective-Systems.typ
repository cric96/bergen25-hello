#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.5.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "utils.typ": *

// Pdfpc configuration
// typst query --root . ./example.typ --field value --one "<pdfpc-file>" > ./example.pdfpc
#let pdfpc-config = pdfpc.config(
    duration-minutes: 30,
    start-time: datetime(hour: 14, minute: 10, second: 0),
    end-time: datetime(hour: 14, minute: 40, second: 0),
    last-minutes: 5,
    note-font-size: 12,
    disable-markdown: false,
    default-transition: (
      type: "push",
      duration-seconds: 2,
      angle: ltr,
      alignment: "vertical",
      direction: "inward",
    ),
  )

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    // handout: true,
    preamble: pdfpc-config,
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
  ),
  config-info(
    title: [Multitier Architectures for Collective Systems],
    // subtitle: [Seminar \@ UniSg],
    author: author_list(
      (
        (first_author("Nicolas Farabegoli"), "nicolas.farabegoli@unibo.it"),
      ), logo: "images/disi.svg"
    ),
    date: datetime(day: 31, month: 03, year: 2025).display("[day] [month repr:long] [year]"),
    // institution: [University of Bologna],
    // logo: align(right)[#image("images/disi.svg", width: 55%)],
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)
#show math.equation: set text(font: "Fira Math")

#set raw(tab-size: 4)
// #show raw: set text(size: 0.85em)
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: (x: 1em, y: 1em),
  radius: 0.7em,
  width: 100%,
)
#show raw.where(block: true): set text(size: 0.75em)

#show bibliography: set text(size: 0.75em)
#show footnote.entry: set text(size: 0.75em)

#set list(marker: box(height: 0.65em, align(horizon, text(size: 2em)[#sym.dot])))

#let emph(content) = text(weight: "bold", style: "italic", content)

// #set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

// == Outline <touying:hidden>

// #components.adaptive-columns(outline(title: none, indent: 1em))

== About Myself

#components.side-by-side(columns: (1fr, 2fr), gutter: 0em)[
  #block(clip: true, radius: 50%, stroke: 0.5em + rgb("#eb811b5f"))[#figure(image("images/PXL_20240322_130744650.square.jpg", width: 85%))]
][
  === Nicolas Farabegoli

  - Ph.D. Student at the _University of Bologna_ (Cesena)
    - 2#super[nd] year in _Computer Science and Engineering_
  - Researcher at the #emph[Pervasive Software Lab] \ #fa-globe() #text(blue)[#link("https://pslab-unibo.github.io")] (prof. Mirko Viroli)

  === Research Scope and Interests

  - *Large-scale* distributed systems
    - *Collective* systems
    - Execution *platforms* in Cloud-Edge environments
  - *Programming languages* and _paradigms_
    - OOP --- Java|Kotlin
    - FP --- Scala #fa-heart(solid: true)
  - *Simulation* and *modeling*
]

= Collective Systems at a Glance

== Collctive Systems

#quote[Complex systems composed of a large number of #underline[devices] that interact each other to achieve a global #underline[common goal]] #cite(label("DBLP:conf/birthday/BucchiaroneM19"))

=== Challenges

#components.side-by-side[
  Complexity in managing large-scale systems:
  - decentralization for *scalability* and *delegation*
  - *autonomic computing* and *self-organization* for #emph[adaptation]
  - *collective computing* for coordination and collaboration
][
  #figure((image("images/step-11.png", width: 70%)))
]

== Collective Self-organizing Applications

#components.side-by-side(columns: (1fr, 1fr))[
  === Core Idea

  A *single program* #math.text("P") describes the _collective_ *self-org* behavior of the system.

  - #emph[Macroprogramming] abstractions
    - _Spatial_ and _temporal_ operators
  - #emph[Proximity-based] interactions
  - Resilient #emph[coordination] mechanisms
][
  #figure((image("images/scr-result.png", width:100%)))
]

#v(1.5em)

#align(center)[
  Shift from a #underline[device-centric] to a *collective-centric* view of the system.

  #underline[Aggregate Computing] #cite(label("DBLP:journals/computer/BealPV15")) as a way to program such systems.
]

== Self-organizing Computational Model

#emph[Behaviour]: _repeated_ execution with #underline[async rounds] \
#emph[Interaction]: _repeated_ *neighbours* #underline[messages exchange] \
#emph[Alignment]: each device execution is *aligned* with the others (program _AST_ alignment)

#line(length: 100%, stroke: 0.05em + rgb("#23373b"))

#only(1)[
  1. Receiving *messages* from neighbours
  #figure(image("images/ac-messages-perception.svg", width: 74%))
]
#only(2)[
  2. Computation of the *macro-program* against the received messages
  #figure(image("images/ac-computation.svg", width: 74%))
]
#only(3)[
  3. Sending to neighbours the *computed* messages
  #figure(image("images/ac-messages-propagation.svg", width: 74%))
]
#only(4)[
  4. Sleep until next *round*...
  #figure(image("images/ac.svg", width: 74%))
]

== Alignment

Each device produces a tree of values where each node in the tree associate a point in the #emph[AST] of the program with the corresponding *value*.
#only("1")[
  #figure(image("images/alignment.svg"))
]
#only("2")[
  #figure(image("images/alignment-1.svg"))
]
#only("3")[
  #figure(image("images/alignment-2.svg"))
]
#only("4")[
  #figure(image("images/alignment-3.svg"))
]

== Aggregate Programming

#components.side-by-side(columns: (2fr, auto))[
  === Field Composition
  ```scala
  def channel(source: Boolean, destination: Boolean): Boolean {
    val toSource = gradient(source) // Field[Double]
    val toDestination = gradient(destination) // Field[Double]
    val distance = distanceTo(source, destination)
    (toSource + toDestination - distance) <= 10
  }
  ```

  Functions take #emph[fields] as *input* and return #emph[field] as *output*.
][
  #figure(image("images/channel.svg", height: 45%))
]

//#v(0.5em)

The entire (_macro_-)program is executed by #emph[all the devices] in the network, assuming that each device *should* execute #emph[all] the functions.

#v(1em)

#only("2")[
  #align(center)[
    #box(fill: rgb("EB801A35"), outset: 0.75em, radius: 1em)[
      It is a "good" assumption?
    ]
  ]
]

#only("3")[
  #align(center)[
    #box(fill: rgb("EB801A35"), outset: 0.75em, radius: 1em)[
      It is a "good" assumption? \
      #underline[Yes but...]
    ]
  ]
]

== Edge-Cloud Continuum (ECC)

#components.side-by-side(gutter: 2em, columns: (2fr, auto))[
  #quote[Aggregation of #emph[computational resources] along the data path from the *edge* to the *cloud* #cite(label("DBLP:journals/access/MoreschiniPLNHT22"))]

  #v(1em)

  We must deal with different #emph[capabilities] and #emph[constraints]:
  - edge devices for #underline[sense/acting], but *resources-constrained*
  - cloud instances for #underline[scalability], but *latency/privacy* issues

  #v(1.5em)

  #only("3")[
    #align(center)[
      #box(fill: rgb("EB801A35"), outset: 0.75em, radius: 1em)[
        How to #underline[deploy] the (macro)program in such infrastructures?
      ]
    ]
  ]
][
  #only("1")[
    #figure(image("images/ac-monolithic-motivation.svg", height: 64%))
  ]
  #only("2-3")[
    #figure(image("images/edge-cloud-continuum.svg", height: 64%))
  ]
]

= Research Gap

// TODO: be more focused on research challenges
== Identified Challenges

=== Modularization

#quote[Collective deployments leverage *only* the #underline[devices] tier, not accounting other #emph[tiers]]

- How can we #emph[partition] our (macro-)system, preserving its #emph[collective] behavior?
- How can we describe the partitioned system in a #emph[uniform] way?

=== Edge-Cloud Continuum

#quote[Modern infrastructures are *dynamics* (openness) and *heterogeneous* (capabilities)]

- How can we #emph[fully exploit] the resources of the #emph[Edge-Cloud Continuum]?
- How can we deal with #emph[different devices] and #emph[platforms]?
- #underline[How] and #underline[when] to #emph[reconfigure] the system?

== Research directions

#show heading: set align(center)
#components.side-by-side[
  === Languages
  
  #v(1em)

  - DSLs
  - Language *Independence*
  - *Transpilation* (heterog.)

  #align(center)[#fa-braille(size: 3em)]
][
  === Platforms

  #v(1em)

  - Comm. *patterns*
  - Deploy *independence*
  - System *specifications*

  #align(center)[#fa-screwdriver-wrench(size: 3em)]
][
  === Reconfigurations

  #v(1em)

  - Resource *management*
  - *On-line* reconfiguration
  - *Predictive* scaling

  #align(center)[#fa-rotate(size: 3em)]
]

= What I have done so far...

== Pulverization -- Foundational work
#show heading: set align(left)

=== Pulverization Model

#components.side-by-side(columns: (1fr, 2fr))[
  #only("1")[
    Split of each *logical device* into #emph[five] #underline[independently deployable] components #cite(label("DBLP:journals/fi/CasadeiPPVW20")):
    - Sensors -- $#math.sigma$
    - Actuators -- $#math.alpha$
    - State -- $#math.kappa$
    - Communication -- $#math.chi$
    - behavior -- $#math.beta$
  ]
  #only("2")[
    A device #emph[round] is the (possibly) *distributed* version of the round introduced before.
  ]
][
  #figure(image("images/image.png", height: 65%))
]

== Pulverization in Action

#components.side-by-side[
=== PulvReAKt #fa-gear()

_Kotlin Multiplatform_ framework implementing the *Pulverization model* #cite(label("DBLP:journals/fgcs/FarabegoliPCV24")).

- #emph[DSL] for specifying system deployments in the *ECC*
- Supports #emph[RabbitMQ] & #emph[MQTT] for _communication_
- Supports _local_ #emph[reconfigurations rules]
][
=== Global Reconfiguration

Formalization of generic *Pulverized architectures* supprting #emph[global-level] reconfigurations #cite(label("DBLP:journals/iot/FarabegoliPCV24")).
 
- Use #emph[Aggregate Programming] for global reconfiguration policies
- Formalization of a #emph[generic pulverized architecture].
]

== Results with Pulverization

#components.side-by-side[
=== Functional benefits

#fa-check-square() Deployments *without rewriting the program* \
#fa-check-square() Components "relocation" preserving *functional correctness*
#v(1.5em)
][
=== Non-functional benefits

#fa-check-square() Good trade-off between *battery consumption* and *cloud costs* \
#fa-check-square() Full exploitation of the *ECC* resources
#fa-check-square() *Global policies* preventing "oscillator" behaviors in reconfiguration
]

=== Cons

#fa-xmark-circle() Partitioning at the *execution level* \
#fa-xmark-circle() *No* support for *modularity* at the *macro-program level*

= A Different Perspective

== Limitations of traditional Pulverization model

=== Intuition

Previous work #cite(label("DBLP:journals/fi/CasadeiPPVW20")) partitioned the #emph[self-org/macroprogram] #underline[execution model] to achieve flexible deployments.
But, it does not consider the *modularity* at the #underline[macro-program level].

#components.side-by-side(columns: (1fr, 1.5fr))[
Each component *can* require one or more #emph[requirements] to be executed.

#box(fill: rgb("EB801A35"), inset: 0.75em, radius: 1em)[
  Not all the *devices* in the network #underline[can satisfy] all the requirements.
]
][
  #figure(image("images/macro-program-requirements.svg", height: 44%))
]

= Multitier Collective Architecture

== Macro Model

#components.side-by-side(columns: (2fr, 1fr))[
  / Macro-program: direct acyclic graph of #emph[components]
  / Component: atomic functional (sub)macro-program taking a list of #emph[inputs] and returning an #emph[output]
  / Port: property of each component through which #emph[values] are received or sent
  / Bindings: models the connections between an #emph[output port] of a component to #underline[one or more] #emph[input ports] of another component
][
  #figure((image("images/partitioned-macro-program.svg")))
]

== Local & Collective Components

#components.side-by-side(columns: (2fr, auto))[
  / Local component: transformation of #emph[local inputs] to #emph[local outputs]
  / Collective components: transformation of local inputs + "implicit" messages from instances of the #emph[same component] in #underline[neighbors] producing #emph[collective output]

  #emph[Local components] do #underline[not require interactions] with other components. \
  #emph[Collective components] require #underline[interactions] with other components instances in neighbors.
][
  #figure((image("images/collective-local-components.svg", height: 60%)))
]

== System Model

/ Application devices: execute the #emph[macro-program] $#text("MP")$
/ Infrastructural devices: #emph[support] the execution of some #underline[components] of the $#text("MP")$

#v(2em)

#figure(image("images/system-model.svg", width: 60%))

== Deployment Model

#components.side-by-side(columns: (2fr, auto))[
  Not all the $text("C")^j_i$ components #emph[can be executed] by the *application devices*.

  It may #emph[lack] _sensors/actuators_, _computational capabilities_, or simply for optimizing _non-functional requirements_.

  In such cases, the $text("C")^j_i$ component is offloaded to an #emph[infrastructural devices], also called *surrogate* for the $text("C")^j_i$ component.
][
  #figure(image("images/offloading-surrogate.svg", height: 65%))
]

The #emph[offloading] can be iteratively applied determinig a *forwarding chain* involving multiple *infrastructural devices*.

== Execution Model

/ Scheduling independence: each #underline[component] is independently #emph[scheduled]
/ Round based execution: each #underline[component] is executed in a #emph[round-based fashion]
/ Message shipping: each #underline[component] execution #emph[produces messages] to be #emph[shipped]

#figure(image("images/message-propagation.svg", width: 60%))

Execution model #emph[formalized] via operational semantics #cite(label("DBLP:conf/acsos/FarabegoliVC24"))

== Scenario

#figure(image("images/rescue-scenario.svg"))

== Deployment

#figure(image("images/rescue-scenario-deployment.svg"))

#figure(image("images/simulation-screenshot-poi.png"))

== Results

*Prototype* model implemented in Scala + ScaFi using #emph[Alchemist Simulator].

#figure(image("images/power_consumption.svg"))

#components.side-by-side(columns: (1fr, 1fr))[
  === Pros

  #fa-check-circle() Opportunistically exploit the #emph[ECC] resources reduces the *power consumption* \
][
  === Cons

  #fa-xmark-circle() Forward chains may introduce #emph[more messages] to be shipped but *optimizations* can be implemented
]

#focus-slide[What's *next*?]

== Framework Implementation

=== Ideas

#fa-lightbulb() *Multitier* approach for managing #emph[system specification] and #emph[deployment] \
#fa-lightbulb() *Capabilities* controlling the #emph[components' placements] over the infrastructure \
#fa-lightbulb() *Runtime* implementation for managing #emph[distributed communication and patterns] \
#fa-lightbulb() *Reconfiguration* and deployments *validation* at runtime \
#fa-lightbulb() ...

== Current Prototype

#components.side-by-side(columns: (2fr, 1fr))[
  === Multitier Architecture for Collective Systems

  #fa-gears() *Local* & *Collective* components support\
  #fa-gears() *Capabilities* with "behavior" for placement control \
  #fa-gears() *DSL* for system #emph[specification] and #emph[deployment] \
  #fa-gears() Component's *scheduling* management

  #v(1em)

  The #emph[prototype] leverages Scala 3 multiplatform.
][
  #figure(image("images/scala-svgrepo-com.svg"))
  #align(center)[
    #text(size: 2em, weight: "bold")[Scala 3]
  ]
]

== Components Definition

`Components` are functions #underline[plus] `Capabilities` for controlling the *placement* of the components over the infrastructure.

```scala
sealed trait Component[-Input <: Product, +Output]:
  type Capabilities

trait LocalComponent[-Input <: Product, +Output] extends Component[Input, Output]:
  def apply(input: Input): Context ?=> Output

trait CollectiveComponent[-Input <: Product, +Output] extends Component[Input, Output]:
  def apply(input: Input): Context ?=> Output
  def sharedData(using ctx: Context): CollectiveData[ctx.DeviceId, Output]
```

== Components Implementation

=== Capabilities definitions

```scala
trait Accelerometer
trait Gps
trait HighComputation
```

=== `LocalComponent` definition

```scala
object PositionSensor extends LocalComponent[EmptyTuple, Coordinate]:
  override type Capabilities = Accelerometer | Gps
  def apply(input: EmptyTuple): Context ?=> Coordinate = ???
```
#fa-warning() `EmptyTuple` for representing the absence of inputs, but respecting the constraints of the `Product` type.
#v(0.7em)
=== `CollectiveComponent` definition

```scala
object CrowdRegions extends CollectiveComponent[Coordinate, Boolean]:
  override type Capabilities = HighComputation
  override def apply(input: Coordinate): Context ?=> Boolean =
    val neighborsData = sharedData
    ???
```

With `shareData` we access to the neighbors' data produced by the same component instances.

*Union* and *intersection* types are used to combine the available capabilities. \
Used later for enforcing valid components #emph[placement] via *type-level* checks.

== Infrasrtucture Definition

As defined in the model, *two physical* devices are defined:  `Application` and `Infrastructural`.

```scala
sealed trait Device:
  type Capabilities
  type Tie

trait Application extends Device

trait Infrastructural extends Device
```

A `Device` exhibits a set of `Capabilities`, and define its `Tie` to the other devices.

== Macroprogram Definition

"Wiring" the components together, we define the #emph[DAG] of the components, resulting in the *macroprogram* definition.

```scala
def macroProgram(using Context) =
  val position = PositionSensor(EmptyTuple)
  val heartbeat = HeartbeatAcquisition(EmptyTuple)
  val alert = RegionsHeartbeatDetection(position *: heartbeat *: EmptyTuple)
  AlertActuation(alert *: EmptyTuple)
```

#fa-warning() Will be resposibility of the #emph[underlying runtime] to renseble the messages from #emph[offloaded] components.

== Infrastructure Specification

This way, we can #emph[define] the "classes" of devices #underline[available in the system].

```scala
trait Smartphone extends Application:
  override type Capabilities = Accelerometer & Gps & Alert
  override type Tie <: Smartphone & Wearable & Edge

trait Wearable extends Infrastructural:
  override type Capabilities = Accelerometer & HeartbeatSensor
  override type Tie <: Wearable & Smartphone

trait Edge extends Infrastructural:
  override type Capabilities = HighComputation
  override type Tie <: Edge & Smartphone
```

== Infrastructure Specification (2)

We can further #emph[specify] the *instances* of the devices.

```scala
object Smartphone1 extends Smartphone
object Smartphone2 extends Smartphone
object Wearable1 extends Wearable
object Wearable2 extends Wearable
object Edge1 extends Edge
```

== Deployment Mapping

*DSL* for specifying the #emph[deployment] of the components over the infrastructure.

```scala
def infrastructureSpecification() =
  deployment:
    forDevice(Smartphone1):
      PositionSensor deployedOn Wearable1
      HeartbeatAcquisition deployedOn Wearable1
      RegionsHeartbeatDetection deployedOn Edge1
      AlertActuation deployedOn Smartphone1
    forDevice(Smartphone2):
      PositionSensor deployedOn Smartphone2
      HeartbeatAcquisition deployedOn Wearable2
      RegionsHeartbeatDetection deployedOn Edge1
      AlertActuation deployedOn Smartphone2
```

#fa-check-circle() *Type-level* checks for the #emph[validity] of the deployment.

#focus-slide[What is *missing*?]

== Future Work

#fa-flask() *Early prototype* exploring feasibility of the approach...

#v(2em)

#fa-rocket() *Runtime* implementation for managing #emph[distribution] \
#fa-rocket() *Reconfiguration* and deployments *validation* at runtime \
#fa-rocket() *How* to #emph[reconfigure] the system at runtime? How can we preserve #emph[safety]?

#align(center)[
  #text(size: 1.75em)[Room for *contribution* or *discussion*! #fa-heart()]
]

= Not only Collective Systems #fa-smile-wink()

== Research Interests

#components.side-by-side(columns: (1fr, 1fr, 1fr))[
  #show heading: set align(center)
  === Infrastructure as Code

  #v(1em)

  #figure(image("images/avatar-on-black.svg", width: 50%))
][
  #show heading: set align(center)
  === Embedded Systems

  #v(1em)

  #figure(image("images/4047376_device_embedded_embedding_internet_iot_icon.svg", width: 50%))
][
  #show heading: set align(center)
  === Distributed Platforms

  #v(1em)

  #figure(image("images/network.svg", width: 50%))


]

#components.side-by-side[
  #show heading: set align(center)
  === Programming Languages

  #v(1em)

  #figure(
    grid(
      columns: 3,
      image("images/scala-svgrepo-com.svg", width: 85%),
      image("images/jb-kotlin.svg", width: 85%),
      image("images/java.svg", width: 85%)
      )
  )
][
  #show heading: set align(center)
  === DevOps

  #v(1em)

  #figure(image("images/Devops-toolchain.svg", width: 50%))

]

#focus-slide[`$ thank you`]



// == Slide
// *Bold* and _italic_ text.

// This is a citation #cite(label("DBLP:journals/fgcs/FarabegoliPCV24")).
// This another citation #cite(label("DBLP:journals/iot/FarabegoliPCV24")

// #alert[This is an alert.]

// == Code slide

// ```kotlin
// fun main() {
//     println("Hello, world!")
//     for (i in 0..9) {
//         println(i)
//     }
//     println("Goodbye, world!")
// }
// ```

// == Title and subtitle slide

// === This is a subtitle

// #lorem(24)

// === This is a subtitle

// #lorem(34)

// == FontAwesome icons

// === Icon in a title #fa-java()

// #fa-icon("github") -- Github icon \
// #fa-icon("github", fill: blue) -- Github icon blue fill

// #slide[
//   #bibliography("bibliography.bib")
// ]
