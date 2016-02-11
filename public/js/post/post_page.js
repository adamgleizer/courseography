import {CourseCategory, MultipleCourseCode, InquiryCategory} from 'es6!post/course_components';
import {SpecialistPost, MajorPost, MinorPost} from 'es6!post/post_components';

var CheckMyPost = React.createClass({

    componentDidMount: function() {
        var activeTab = this.refs.postNav.getActiveTab() + 'Post';
        this.changeActiveTab(activeTab);
    },

    changeActiveTab: function(newTab) {
        var activeTab = newTab;
        var tabs = ['spePost', 'majPost', 'minPost'];
        var me = this;

        tabs.forEach(function(tab) {
            if (tab === activeTab) {
                me.refs[tab].changeTabView(true);
            } else {
                me.refs[tab].changeTabView(false);
            }
        });
    },

    render: function() {
        return (
            <div id='check_my_post'>
                <PostNav ref='postNav' updateTab={this.changeActiveTab}/>
                <SpecialistPost ref='spePost'/>
                <MajorPost ref='majPost' />
                <MinorPost ref='minPost' />
            </div>
        );
    }
});


var PostNav = React.createClass({
    getInitialState: function() {
        return {
            visible: this.getActiveTab() === '' ? 'spe' : this.getActiveTab()
        }
    },

    getActiveTab: function() {
        return getCookie('activePost');
    },

    changeActiveTab: function(e) {
        var newVisible = e.target.id.substring(0, 3);
        this.setState({visible: newVisible}, function() {
            this.props.updateTab(newVisible + 'Post');
            setCookie('activePost', newVisible);
        });
    },

    getNavClass: function(type) {
        return this.state.visible === type ? 'nav_selected' : 'nav_not_selected';
    },

    render: function() {
        return (
            <nav id='posts'> 
                <ul>
                    <li id='specialist' className={this.getNavClass('spe')}>
                        <a id='spec_link' onClick={this.changeActiveTab}> Specialist </a>
                        <div id='spec_creds'> (0/12.0) </div>
                    </li>
                    <li id='major' className={this.getNavClass('maj')}>
                        <a id='maj_link' onClick={this.changeActiveTab}> Major </a>
                        <div id='maj_creds'> (0/8.0) </div>
                    </li>
                    <li id='minor' className={this.getNavClass('min')}>
                        <a id='min_link' onClick={this.changeActiveTab}> Minor </a>
                        <div id='min_creds'> (0/4.0) </div>
                    </li>
                </ul>
            </nav>
        );
    }

});


export default {CheckMyPost: CheckMyPost};
