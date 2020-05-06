obs <- cbs4_get_observations("84287NED", Perioden="2019MM12")
obs # without label columns

obs_labeled <- cbs4_add_labels(obs)
obs_labeled


d <- cbs4_get_data("84287NED", Perioden="2019MM12")
d # cbs4_get_data automagically labels measure columns.
d_labeled <- cbs4_add_labels(d)
d_labeled

