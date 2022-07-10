provider "google" {
  project = var.project
  region  = var.region
  
  }

resource "google_data_loss_prevention_deidentify_template" "basic" {
    parent = "projects/my-project-lab1-351507"
    description = "Deidentify using TF"
    display_name = "DisplaynameFrifrntify template-TF"

    deidentify_config {
        info_type_transformations {
            transformations {
                info_types {
                    name = "FIRST_NAME"
                }

                primitive_transformation {
                    replace_with_info_type_config = true
                }
            }

            transformations {
                info_types {
                    name = "PHONE_NUMBER"
                }
                info_types {
                    name = "AGE"
                }

                primitive_transformation {
                    replace_config {
                        new_value {
                            integer_value = 9
                        }
                    }
                }
            }

            transformations {
                info_types {
                    name = "EMAIL_ADDRESS"
                }
                info_types {
                    name = "LAST_NAME"
                }

                primitive_transformation {
                    character_mask_config {
                        masking_character = "X"
                        number_to_mask = 4
                        reverse_order = true
                        characters_to_ignore {
                            common_characters_to_ignore = "PUNCTUATION"
                        }
                    }
                }
            }

            transformations {
                info_types {
                    name = "DATE_OF_BIRTH"
                }

                primitive_transformation {
                    replace_config {
                        new_value {
                            date_value {
                                year  = 2020
                                month = 1
                                day   = 1
                            }
                        }
                    }
                }
            }

      transformations {
        info_types {
          name = "CREDIT_CARD_NUMBER"
        }

        primitive_transformation {
          crypto_deterministic_config {
            context {
              name = "sometweak"
            }
            crypto_key {
              transient {
                name = "beep"
              }
            }
            surrogate_info_type {
              name = "abc"
            }
          }
        }
      }
        }
    }
}
################################################################
resource "google_data_loss_prevention_inspect_template" "basic" {
    parent = "projects/my-project-lab1-351507"
    description = "Inspect"
    display_name = "Inspect-TF"

    inspect_config {
        info_types {
            name = "EMAIL_ADDRESS"
        }
        info_types {
            name = "PERSON_NAME"
        }
        info_types {
            name = "LAST_NAME"
        }
        info_types {
            name = "DOMAIN_NAME"
        }
        info_types {
            name = "PHONE_NUMBER"
        }
        info_types {
            name = "FIRST_NAME"
        }

        min_likelihood = "UNLIKELY"
        rule_set {
            info_types {
                name = "EMAIL_ADDRESS"
            }
            rules {
                exclusion_rule {
                    regex {
                        pattern = ".+@example.com"
                    }
                    matching_type = "MATCHING_TYPE_FULL_MATCH"
                }
            }
        }
        rule_set {
            info_types {
                name = "EMAIL_ADDRESS"
            }
            info_types {
                name = "DOMAIN_NAME"
            }
            info_types {
                name = "PHONE_NUMBER"
            }
            info_types {
                name = "PERSON_NAME"
            }
            info_types {
                name = "FIRST_NAME"
            }
            rules {
                exclusion_rule {
                    dictionary {
                        word_list {
                            words = ["TEST"]
                        }
                    }
                    matching_type = "MATCHING_TYPE_PARTIAL_MATCH"
                }
            }
        }

        rule_set {
            info_types {
                name = "PERSON_NAME"
            }
            rules {
                hotword_rule {
                    hotword_regex {
                        pattern = "patient"
                    }
                    proximity {
                        window_before = 50
                    }
                    likelihood_adjustment {
                        fixed_likelihood = "VERY_LIKELY"
                    }
                }
            }
        }

        limits {
            max_findings_per_item    = 10
            max_findings_per_request = 50
            max_findings_per_info_type {
                max_findings = "75"
                info_type {
                    name = "PERSON_NAME"
                }
            }
            max_findings_per_info_type {
                max_findings = "80"
                info_type {
                    name = "LAST_NAME"
                }
            }
        }
    }
}
###########################################################
resource "google_data_loss_prevention_job_trigger" "basic" {
    parent = "projects/my-project-lab1-351507"
    description = "Job trigger 1"
    display_name = "job trigger1.1"

    triggers {
        schedule {
            recurrence_period_duration = "86400s"
        }
    }

    inspect_job {
        inspect_template_name = "fake"
        actions {
            save_findings {
                output_config {
                    table {
                        project_id = "my-project-lab1-351507"
                        dataset_id = "dlpins"
                    }
                }
            }
        }
        storage_config {
            cloud_storage_options {
                file_set {
                    url = "gs://dlins/dlp/"
                }
            }
        }
    }
}
####################################################
resource "google_data_loss_prevention_stored_info_type" "basic" {
    parent = "projects/my-project-lab1-351507"
    description = "InfoType-Sample"
    display_name = "Infotype-sample-patient"

    regex {
        pattern = "patient"
        group_indexes = [2]
    }
}