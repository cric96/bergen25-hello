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
      )
    ),
    date: datetime(day: 31, month: 03, year: 2025).display("[day] [month repr:long] [year]"),
    // institution: [University of Bologna],
    logo: align(right)[#image("images/disi.svg", width: 55%)],
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
][
  #figure(image("images/edge-cloud-continuum.svg", height: 64%))
]

  // #align(center)[
  //   The #alert[opportunistic] use of the _continuum_ offers new possibilities, \
  //   but requires fexible #alert[deployment] strategies.
  // ]


// == Slide
// *Bold* and _italic_ text.

// This is a citation #cite(label("DBLP:journals/fgcs/FarabegoliPCV24")).
// This another citation #cite(label("DBLP:journals/iot/FarabegoliPCV24"))

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
