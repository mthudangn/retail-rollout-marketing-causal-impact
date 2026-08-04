.PHONY: setup run test

setup:
	Rscript requirements.R

run:
	Rscript run_pipeline.R

test:
	Rscript -e 'testthat::test_dir("tests/testthat")'
