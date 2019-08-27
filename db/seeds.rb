# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create({
    login: "jsmith", name: "John Smith", provider: "github"
})

Article.create([
    {title: "Title", content: "Content", slug: "Slug-01", user: user},
    {title: "Title", content: "Content", slug: "Slug-02", user: user},
    {title: "Title", content: "Content", slug: "Slug-03", user: user},
    {title: "Title", content: "Content", slug: "Slug-04", user: user},
    {title: "Title", content: "Content", slug: "Slug-05", user: user},
    {title: "Title", content: "Content", slug: "Slug-06", user: user},
    {title: "Title", content: "Content", slug: "Slug-07", user: user},
    {title: "Title", content: "Content", slug: "Slug-08", user: user},
    {title: "Title", content: "Content", slug: "Slug-09", user: user},
    {title: "Title", content: "Content", slug: "Slug-10", user: user},
    {title: "Title", content: "Content", slug: "Slug-11", user: user},
    {title: "Title", content: "Content", slug: "Slug-12", user: user},
    {title: "Title", content: "Content", slug: "Slug-13", user: user},
    {title: "Title", content: "Content", slug: "Slug-14", user: user},
    {title: "Title", content: "Content", slug: "Slug-15", user: user}
])