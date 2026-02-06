#let source_text(source_info) = {
  align(right)[
    #text(
      source_info,
      font: "Lao MN",
      size: 9pt,
      style: "italic",
    )]
}

#let horline() = { line(length: 100%, stroke: 2pt + rgb("#94733f")) }

#let report(
  title: none,
  subtitle: none,
  date: none,
  content,
) = {
set page(
    paper: "us-letter",
    margin: (top: 0.5in, bottom: 1in, x: 0.75in),
    footer: {
      rect(
        width: 100%,
        height: 0.75in,
        outset: (x: 15%),
        fill: rgb("#a09c21"),
        pad(top: 16pt, block([
          #grid(
            columns: (75%, 25%),
            align(left)[
              #text(
                upper(subtitle),
                font: "Lantinghei SC",
                fill: white,
                weight: "bold",
              )
            ],
            align(right)[
              #text(
                upper(date),
                font: "Lantinghei SC",
                fill: white,
                weight: "bold",
              )
            ],
          )
        ])),
      )
    },
  )
  set text(
    lang: "en",
    region: "US",
    font: "Lao MN",
    size: 11pt,
  )
  show heading: it => {
    let sizes = (
      "1": 16pt, // Heading level 1
      "2": 10pt, // Heading level 2
    )
    let level = str(it.level)
    let size = sizes.at(level)
    let formatted_heading = if level == "2" { it } else { upper(it) }
    let alignment = if level == "2" { center } else { left }

    set text(
      font: "Lantinghei SC",
      fill: rgb("#141413"),
      size: size,
      weight: "bold",
    )
    align(alignment)[#formatted_heading]
  }

  image("logo.png", width: 1in)

  horline()

  grid(
    columns: (80%, 15%, 5%),
    align(left)[
      #text(
        upper(title),
        font: "Lantinghei SC",
        size: 20pt,
        fill: rgb("#141413"),
        weight: "bold",
      )
    ],
    align(right)[
      #image("logo copy.png", width: 1.5in)
    ],
    align(right)[],
  )

  horline()

  content
}