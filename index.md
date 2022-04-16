---
layout: default
title: Home
nav_order: 1
description: "Kgen"
permalink: /
---

# Kgen
{: .fs-9 }

Kgen provides multi-language tools for calculating stoichiometric equilibirium constants (Ks) in the ocean at given Temperatire, Salinity, Pressure, [Mg] and [Ca].
{: .fs-6 .fw-300 }
[Find out about Kgen](/about){: .btn .fs-5 .mb-4 .mb-md-0 }

## Use Kgen

Kgen is available for use in Matlab, Python and R.
{: .fs-6 .fw-300 }
[Get started in Matlab](/Matlab/getting-started){: .btn .fs-5 .mb-4 .mb-md-0 } [Get started in Python](Python/getting-started){: .btn .fs-5 .mb-4 .mb-md-0 } [Get started in R](R/getting-started){: .btn .fs-5 .mb-4 .mb-md-0 }

---

### License

Kgen is open-source and distributed under an [MIT license](https://github.com/PalaeoCarb/Kgen/blob/main/LICENSE).

### Contributing

We welcome contributions to Kgen. Please communicate your intentions by first submitting an issue on the [Kgen GitHub repo](https://github.com/PalaeoCarb/Kgen/issues/new), so we can discuss how best to integrate your contributions.

Kgen was built by [Oscar Branson](https://github.com/oscarbranson), [Dennis Mayk](https://github.com/dm807cam), and [Ross Whiteford](https://github.com/rossidae).

#### Thank you all who have contributed to Kgen!

<ul class="list-style-none">
{% for contributor in site.github.contributors %}
  <li class="d-inline-block mr-1">
     <a href="{{ contributor.html_url }}"><img src="{{ contributor.avatar_url }}" width="32" height="32" alt="{{ contributor.login }}"/></a>
  </li>
{% endfor %}
</ul>
