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
#show raw: set text(size: 0.75em)
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: (x: 1em, y: 1em),
  radius: 0.7em,
  width: 100%,
)

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
  - Researcher at the #emph[Pervasive Systems] lab

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
        How to #underline[deploy] the program in such infrastructures?
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

== Identified Challenges

#quote[Collective deployments leverage *only* the #underline[devices] tier, not accounting other #emph[tiers]]

- How can we #emph[partition] our (macro-)system, preserving its #emph[collective] behavior?
- How can we describe the partitioned system in a #emph[uniform] way?

#v(2em)

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

= What we have done so far...

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
    A device #emph[round] is composed of:
    1. Collect *sensors* data, the previous *state*, and *neighbor messages*
    2. Apply the *behavior* with collected data
    3. Update the *state*, *send messages* to neighbors, and *actuate* over the environment
    4. Sleep until the next round...
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
