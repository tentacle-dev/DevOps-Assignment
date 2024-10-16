const index = (req,res) => {
    res.render('index', { title: 'Docker Assignment' });
    
}

module.exports = {
    index
}