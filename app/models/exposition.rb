module Exposition
  # Defines the required JSON output format for the exposition commentary. This
  # schema ensures that the commentary includes Bible text, context, key themes,
  # highlights, analyses, cross-references, alternative interpretations,
  # personal applications, insights, reflections, and a summary.
  STRUCTURED_OUTPUT_JSON_SCHEMA = <<~JSON
    {
      "type": "json_schema",
      "name": "scripture_study",
      "schema": {
        "type": "object",
        "properties": {
          "text": {
            "type": "string",
            "description": "The Bible text being commented on, quoted verbatim from the Berean Standard Bible (BSB)."
          },
          "context": {
            "type": "string",
            "description": "Historical, cultural, and linguistic background of the text."
          },
          "key_themes": {
            "type": "array",
            "description": "Main theological themes in the text. Include all relevant themes without limiting to a fixed number—provide as many items as the text richness demands.",
            "items": {
              "type": "object",
              "properties": {
                "theme": {
                  "type": "string",
                  "description": "A central theme or theological concept present in the text."
                },
                "description": {
                  "type": "string",
                  "description": "A brief explanation of the theme."
                }
              },
              "required": [
                "theme",
                "description"
              ],
              "additionalProperties": false
            }
          },
          "highlights": {
            "type": "array",
            "description": "A list of key highlights from the text that capture its most striking or memorable insights. Each item should be a concise, well-explained blurb that provides a complete and useful explanation of the impact of the text, selecting only the most powerful insights rather than listing every minor detail.",
            "items": {
              "type": "string"
            }
          },
          "analyses": {
            "type": "array",
            "description": "An exhaustive, phrase-by-phrase exposition breaking down every phrase in the text. Each item should provide a comprehensive exposition of the text, to ensure that all phrases are addressed. Use as many tokens as necessary for a full response as this is the core of the response. If the passage includes ambiguous or multi-interpretable language, your analysis should note where further study may be beneficial, ensuring that every significant phrase is fully addressed.",
            "items": {
              "type": "object",
              "properties": {
                "part": {
                  "type": "string",
                  "description": "Part of the text being analysed quoted verbatim."
                },
                "note": {
                  "type": "string",
                  "description": "Explanatory note or interpretation of the part of text."
                }
              },
              "required": [
                "part",
                "note"
              ],
              "additionalProperties": false
            }
          },
          "cross_references": {
            "type": "array",
            "description": "Other Bible passages that relate to or illuminate the current text. List all relevant references to support the commentary.",
            "items": {
              "type": "object",
              "properties": {
                "reference": {
                  "type": "string",
                  "description": "The reference of the related Bible passage."
                },
                "note": {
                  "type": "string",
                  "description": "A brief note explaining the connection."
                }
              },
              "required": [
                "reference",
                "note"
              ],
              "additionalProperties": false
            }
          },
          "alternative_interpretations": {
            "type": "array",
            "description": "Brief outline of significant alternative or minority interpretations on the text that may be an empty list if there are none. If a minority interpretation is required to be the primary focus, the majority interpretation should appear here. In the case the commentary naturally reflects multiple valid perspectives (blended approach), present the majority (traditional) interpretation in the primary commentary and include additional perspectives here. Where ambiguous language exists, include a note that further study may be warranted.",
            "items": {
              "type": "object",
              "properties": {
                "title": {
                  "type": "string",
                  "description": "The title of the alternative interpretation."
                },
                "note": {
                  "type": "string",
                  "description": "A description or explanation of the alternative interpretation."
                }
              },
              "required": [
                "title",
                "note"
              ],
              "additionalProperties": false
            }
          },
          "personal_applications": {
            "type": "array",
            "description": "Practical takeaways and personal applications for Christian living derived from the text. Ensure the list is exhaustive and reflects all applicable insights.",
            "items": {
              "type": "object",
              "properties": {
                "title": {
                  "type": "string",
                  "description": "The title of the application point."
                },
                "note": {
                  "type": "string",
                  "description": "A description or explanation of the application."
                }
              },
              "required": [
                "title",
                "note"
              ],
              "additionalProperties": false
            }
          },
          "christ_centered_insights": {
            "type": "array",
            "description": "Insights explaining how the text connects to Jesus Christ, salvation, and God's redemptive plan. Provide a varied and comprehensive list of insights.",
            "items": {
              "type": "string",
              "description": "A single Christ-centered insight from the text."
            }
          },
          "reflections": {
            "type": "array",
            "description": "Reflective questions or meditation prompts based on the text. Include as many reflective prompts as necessary to encourage deep personal meditation.",
            "items": {
              "type": "string",
              "description": "A reflective prompt."
            }
          },
          "interpretation_type": {
            "type": "string",
            "enum": [
              "blended",
              "majority",
              "minority"
            ],
            "description": "Indicates whether the primary interpretation in the commentary is the majority (traditional) view, a minority (alternative) view or blended (multiple valid interpretations)"
          },
          "places": {
            "type": "array",
            "description": "List of places named in the text. This list can be empty if no places are mentioned.",
            "items": {
              "type": "string"
            }
          },
          "people": {
            "type": "array",
            "description": "List of people or characters named in the text. This list can be empty if no names are mentioned.",
            "items": {
              "type": "string"
            }
          },
          "tags": {
            "type": "array",
            "description": "A collection of succinct metadata keywords that capture the text's key theological themes, cultural context, and doctrinal elements. These tags aid in backend filtering and analysis - for example, tags might include 'creation', 'redemption', 'covenant', or 'historical context'.",
            "items": {
              "type": "string"
            }
          },
          "summary": {
            "type": "string",
            "description": "A well-written, engaging exposition in Markdown format that seamlessly integrates all the structured data points: text, context, key themes, highlights, analyses, cross-references, alternative interpretations (if available), practical personal applications, Christ-centered insights, and reflections. The text should be written in a friendly, conversational tone that feels warm and approachable, yet remains theologically sound and reflective, having Scripture quotes naturally embedded within the discussion (where it makes sense to). Avoid using additional headings (since the content will be placed within a `div` with its own headings) and instead use clear paragraphs and subtle dividers. Leveraging features like **bold** for emphasis and *italics* for clarity as needed. When composing the summary, follow these formatting guidelines for clarity and visual diversity: i) Use **both bold and *italics*** to highlight verbatim quoted text from the Bible. This dual formatting should make the quoted text stand out distinctly, ii) Use **bold** alone to emphasise chapter and verse references, key terms, major themes, or pivotal statements and, iii) Use *italics* alone to stress important concepts or to introduce and explain biblical terms in plain English. The summary should recap previously presented insights without introducing new material, ensuring a clear and engaging conclusion."
          }
        },
        "required": [
          "text",
          "context",
          "key_themes",
          "highlights",
          "analyses",
          "cross_references",
          "alternative_interpretations",
          "personal_applications",
          "christ_centered_insights",
          "reflections",
          "interpretation_type",
          "places",
          "people",
          "tags",
          "summary"
        ],
        "additionalProperties": false
      },
      "strict": true
    }
  JSON

  def self.table_name_prefix
    "exposition_"
  end
end
