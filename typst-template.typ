#let status-box(top-box-text: "", bottom-box-text: none, top-fill: rgb("#36637d")) = {
  let top_box = box(
    width: 2in,
    height: 0.7in,
    fill: top-fill,
    inset: 6pt,
    align(center + horizon)[
      #text(fill: white, weight: "bold", size: 14pt)[#top-box-text]
    ],
  )

  let bottom_box = box(
    width: 2in,
    height: 0.7in,
    fill: top-fill.lighten(80%),
    inset: 6pt,
    align(center + horizon)[
      #text(fill: black, size: 14pt)[#bottom-box-text]
    ],
  )

  stack(top_box, bottom_box, spacing: 0pt)
}

#let source_text(source_info) = {
  align(right)[
    #text(
      source_info,
      font: "Lao MN",
      size: 9pt,
      style: "italic",
    )]
}

#let horline() = { line(length: 100%, stroke: 20pt + rgb("#36637d")) }

#let report(
  title: none,
  subtitle: none,
  date: none,
  content,
) = {
set page(
      background: [
      opacity(8%)[
        align(center)[
          #image("background.png", width: 100%, height: 100%)
        ]
      ]
    ],
    paper: "us-letter",
    margin: (top: 0.5in, bottom: 1in, x: 0.75in),
    footer: {
      rect(
        width: 100%,
        height: 0.75in,
        outset: (x: 15%),
        fill: rgb("#141413"),
        pad(top: 15pt, block([
          #grid(
            columns: (75%, 25%),
            align(left)[
                #grid(
                  columns: (25%, 20%, 45%),
                  align(left)[
                    #text(
                      "Prepared By:",
                      font: "Lantinghei SC",
                      fill: white,
                      weight: "bold",
                    )
                  ],
                  align(right)[
                    #v(-5pt)
                    #image("logo copy.png", width: 1.2in)
                  ],
                  align(right)[
                    #text(
                      "www.centralstatz.com",
                      font: "Lantinghei SC",
                      fill: white,
                      size: 10pt
                    )
                  ],
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

  horline()

  grid(
    columns: (5%, 45%, 45%, 5%),
    align(left)[],
    align(center)[
      #pad(top: 15pt, block([
        #text(
          upper(title),
          font: "Lantinghei SC",
          size: 20pt,
          fill: rgb("#141413"),
          weight: "bold"
        )
      ]))
    ],
    align(center)[
      #image("logo.png", width: 1in)
      #v(-15pt)
      #text(
        subtitle,
        font: "Lao MN",
        size: 8pt,
        fill: rgb("#141413")
      )
    ],
    align(left)[]
  )

  horline()

  content
}